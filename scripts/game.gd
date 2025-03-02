class_name Game extends Node2D

@onready var lasers = $Lasers
#@onready var jugador = $Jugador
@onready var asteroides = $AsteroidesIniciales
@onready var hud = $UI/HUD
@onready var pantallaDeGameOver = $UI/MenuGameOver
@onready var zonaReaparicion = $ZonaDeReaparicion
@onready var areaDeSpawnDelJugador = $ZonaDeReaparicion/SpawnJugador
@onready var musicaMenu = $MusicaMenu
@onready var musicaInGame = $MusicaInGame

var vidas = GLOBAL.game_data["vidasMaximas"]
var puntuacion = GLOBAL.game_data["puntos"]

var jugador = preload("res://scennes/jugador.tscn").instantiate()

var escenaAsteroides = preload("res://scennes/asteroide.tscn")

func _ready() -> void:
	GLOBAL.load_game()
	actualizarPuntuacionVidas()

	#Logica de aparición del menú
	if !GLOBAL.jugando:
		musicaMenu.play()
		pantallaDeGameOver.visible = true
	else:
		musicaMenu.stop()
		jugador.position = Vector2(800, 450)
		add_child(jugador)

	jugador.connect("disparoLaser", _disparoJugador)
	jugador.connect("muerto", _jugadorMuerto)
	
	for asteroide in asteroides.get_children():
		asteroide.connect("explotar", _asteroideExplotado)
	
func _process(delta):
	
	if !GLOBAL.jugando and !musicaMenu.is_playing():
		musicaInGame.stop()
		musicaMenu.play()
		
		
	if GLOBAL.jugando and !musicaInGame.is_playing():
		musicaMenu.stop()
		musicaInGame.play()
		
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _disparoJugador(laser):
	$SonidoLaser.play()
	lasers.add_child(laser)

func _asteroideExplotado(posicion, tamaño, puntos):
	$SonidoGolpearAsteroide.play()
	GLOBAL.set_añadir_puntos(puntos)
	hud.puntuacion = GLOBAL.get_puntos()
	for i in range(2):
		match tamaño:
			asteroide.TamañosDeAsteroides.GRANDE:
				spawn_asteroides(posicion, asteroide.TamañosDeAsteroides.MEDIO)
			asteroide.TamañosDeAsteroides.MEDIO:
				spawn_asteroides(posicion, asteroide.TamañosDeAsteroides.PEQUEÑO)
			asteroide.TamañosDeAsteroides.PEQUEÑO:
				pass
	print(GLOBAL.get_puntos())
		

func spawn_asteroides(pos, size):
	var a = escenaAsteroides.instantiate()
	a.global_position = pos
	a.size = size
	a.connect("explotar", _asteroideExplotado)
	asteroides.call_deferred("add_child", a)
	
func _jugadorMuerto():
	$SonidoMuerteJugador.play()
	var posicionNaveMuerta = jugador.global_position
	vidas -= 1
	hud.iniciarVidas(vidas)
	jugador.global_position = areaDeSpawnDelJugador.global_position
	
	if vidas <= 0:
		await get_tree().create_timer(2).timeout
		pantallaDeGameOver.visible = true
		GLOBAL.jugando = false
		vidas = GLOBAL.get_vidas_maximas()
		actualizarPuntuacionVidas()
		
	else:
		await get_tree().create_timer(1).timeout
		while !areaDeSpawnDelJugador.estaVacio:
			await get_tree().create_timer(0.1).timeout
		jugador.reaparecer(zonaReaparicion.global_position)


func _on_timer_timeout() -> void:
	var generadorDeMobs = $PathGenerarMobs/PathFollow2D
	generadorDeMobs.progress_ratio = randf()
	var a = escenaAsteroides.instantiate() 
	a.connect("explotar", _asteroideExplotado)
	asteroides.add_child(a)


func _on_auto_guardado_timeout() -> void:
	
	if GLOBAL != null:
		GLOBAL.save_game()
	else:
		print("ERROR: GLOBAL no está cargado")
	
	print("Guardando")

func actualizarPuntuacionVidas():
	puntuacion = GLOBAL.game_data["puntos"]
	vidas = GLOBAL.game_data["vidasMaximas"]
	hud.cambiarScore(puntuacion)
	hud.iniciarVidas(vidas)
