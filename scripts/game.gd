# Clase principal del juego. Se encarga de la lógica general y del control de los elementos principales.
class_name Game extends Node2D

# Referencias a nodos importantes de la escena
@onready var lasers = $Lasers
@onready var asteroides = $AsteroidesIniciales
@onready var navesEnemigas = $NavesEnemigas
@onready var hud = $UI/HUD
@onready var pantallaDeGameOver = $UI/MenuPrincipal
@onready var zonaReaparicion = $ZonaDeReaparicion
@onready var areaDeSpawnDelJugador = $ZonaDeReaparicion/SpawnJugador
@onready var asteroidesDosHits = $AsteroidesDosHits
# Sonidos del juego
@onready var musicaMenu = $Sonido/MusicaMenu
@onready var musicaInGame = $Sonido/MusicaInGame
@onready var disparoJugador = $Sonido/SonidoLaser
@onready var sonidoGolpearNaveKamikaze = $Sonido/NaveKamikazeGolpeada
@onready var sonidoMuerteJugador = $Sonido/SonidoMuerteJugador

# Variables que contienen el estado del juego
var vidas = GameData.game_data["vidas"]
var puntuacion = GameData.game_data["puntos"]
var jugador = null
var escenaAsteroides = preload("res://scennes/asteroide.tscn")
var escenaNavesEnemigas = preload("res://scennes/naveEnemiga.tscn")

func _ready() -> void:
	# Cargamos una nave u otra en base a si tenemos la mejora de cañones o no
	if GameData.get_numero_cañones() == 1:
		jugador = preload("res://scennes/jugador.tscn").instantiate()
	else:
		jugador = preload("res://scennes/jugador2cañones.tscn").instantiate()
	
	# Cargamos los datos almacenados del juego
	GameData.load_game()
	
	# Actualizamos el hud
	actualizarPuntuacionVidas()

	# Logica de aparición del menú
	if !GameData.jugando:
		musicaMenu.play()
		pantallaDeGameOver.visible = true
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN # Si se esta jugando se esconde el ratón
		musicaMenu.stop()
		jugador.position = Vector2(960, 540)
		add_child(jugador)

	# Conecto las señales del jugador
	jugador.connect("disparoLaser", _disparoJugador)
	jugador.connect("muerto", _jugadorMuerto)
	
	for asteroidesAlamacenados in asteroides.get_children():
		asteroidesAlamacenados.connect("explotar", _asteroideExplotado)
	
func _process(delta):
	# Lógica de los sonidos
	if !GameData.jugando and !musicaMenu.is_playing():
		musicaInGame.stop()
		musicaMenu.play()
		
	if GameData.jugando and !musicaInGame.is_playing():
		musicaMenu.stop()
		musicaInGame.play()
		
	if !GameData.jugando and navesEnemigas != null:
		navesEnemigas.queue_free()
		
func _disparoJugador(laser):
	# Generamos un laser y ejecutamos el sonido de laser
	disparoJugador.play()
	lasers.add_child(laser)

	# Esta función es llamada cuando explota un asteroide
func _asteroideExplotado(puntos):	
	# Se suman los puntos por explotarlo
	GameData.set_añadir_puntos(puntos)
	
	# Se actualiza el HUD
	hud.puntuacion = GameData.get_puntos()

func _naveExplotada(puntos):
	# Se ejecuta el sonido de explosión de asteroide
	sonidoGolpearNaveKamikaze.play()
	
	# Se suman los puntos por explotarlo
	GameData.set_añadir_puntos(puntos)
	
	# Se actualiza el HUD
	hud.puntuacion = GameData.get_puntos()

# Genera un asteroide en la posición y del tamaño pasado por parametro.
func spawn_asteroides(pos, size):
	var a = escenaAsteroides.instantiate()
	a.global_position = pos
	a.size = size
	a.connect("explotar", _asteroideExplotado)
	asteroidesDosHits.call_deferred("add_child", a)
	
# Se llama cuando el jugador muere.
func _jugadorMuerto():
	sonidoMuerteJugador.play()
	vidas -= 1
	hud.iniciarVidas(vidas)
	jugador.global_position = areaDeSpawnDelJugador.global_position
	
	# Si no tiene vidas se muestra el menu principal y si tiene sigue jugando
	if vidas <= 0:
		await get_tree().create_timer(2).timeout
		mostrarMenuPrincipalAlMorir()
	else:
		await get_tree().create_timer(1).timeout
		$Timers/TimerSpawnAsteroides.stop()
		areaDeSpawnDelJugador.controlLimpiezaZonaReaparicion()
		await get_tree().create_timer(0.1).timeout
		jugador.reaparecer(zonaReaparicion.global_position)
		$Timers/TimerSpawnAsteroides.start()

# Muestra el menú principal
func mostrarMenuPrincipalAlMorir():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE # Hace el ratón visible
	pantallaDeGameOver.visible = true
	
	# Actualiza los datos del jugador
	GameData.jugando = false
	jugador.morir()
	vidas = GameData.get_vidas()
	actualizarPuntuacionVidas()
	GameData.save_game()

# Esta función genera asteroides en base a un timer
func _on_timer_timeout() -> void:
	if GameData.jugando:
		crear_enemigo_asteroide()
		crear_enemigos_asteroide_dos_hits()
		crear_enemigo_nave()

func crear_enemigos_asteroide_dos_hits():
		var a = preload("res://scennes/asteroideDosDeVida.tscn").instantiate()
		a.global_position = obtener_posicion_fuera_de_pantalla()
		a.rotation = obtener_rotacion_hacia_centro(a.global_position)
		a.connect("explotar", _asteroideExplotado)
		asteroides.add_child(a)
		
func crear_enemigo_asteroide():
	var a = escenaAsteroides.instantiate()
	a.global_position = obtener_posicion_fuera_de_pantalla()
	a.rotation = obtener_rotacion_hacia_centro(a.global_position)
	a.connect("explotar", _asteroideExplotado)
	asteroides.add_child(a)

func crear_enemigo_nave():
	var nuevaNave = escenaNavesEnemigas.instantiate()
	nuevaNave.global_position = obtener_posicion_fuera_de_pantalla()
	nuevaNave.connect("desaparecer", _naveExplotada)
	var posicionInicial = obtener_posicion_fuera_de_pantalla()
	nuevaNave.global_position = posicionInicial

	var direccion = (jugador.global_position - posicionInicial).angle()
	nuevaNave.rotation = direccion
	nuevaNave.iniciar_direccion(jugador.global_position)

	navesEnemigas.add_child(nuevaNave)

# Guardado automático de la partida
func _on_auto_guardado_timeout() -> void:
	if GameData.jugando:
		GameData.save_game()

# Refresca la información de las vidas en el HUD
func actualizarPuntuacionVidas():
	puntuacion = GameData.game_data["puntos"]
	vidas = GameData.game_data["vidas"]
	hud.cambiarScore(puntuacion)
	hud.iniciarVidas(vidas)

# Refresca la información toda la información del HUD
func actualizarPuntuacionVidasReinicio():
	puntuacion = GameData.game_data["puntosInicio"]
	vidas = GameData.game_data["vidasIniciales"]
	hud.cambiarScore(puntuacion)
	hud.iniciarVidas(vidas)

# Refresca sólo la puntuación en el HUD.
func actualizar_hud_score():
	hud.cambiarScore(GameData.get_puntos())

# Refresca la información de las vidas en el HUD	
func actualizar_hud_vidas():
	hud.iniciarVidas(GameData.get_vidas())

# Se calcula una posición aleatoria fuera de la pantalla para generar los enemigos
func obtener_posicion_fuera_de_pantalla() -> Vector2:
	var pantalla = get_viewport().get_visible_rect().size
	var margen = 100  # distancia desde el borde
	var lado = randi() % 4
	match lado:
		0: return Vector2(randf_range(0, pantalla.x), -margen) # arriba
		1: return Vector2(randf_range(0, pantalla.x), pantalla.y + margen) # abajo
		2: return Vector2(-margen, randf_range(0, pantalla.y)) # izquierda
		3: return Vector2(pantalla.x + margen, randf_range(0, pantalla.y)) # derecha
	return Vector2.ZERO

# esta función hace que aparezcan los enemigos en dirección al jugador
func obtener_rotacion_hacia_centro(pos: Vector2) -> float:
	var centro = get_viewport().get_visible_rect().size / 2
	return (centro - pos).angle()
