extends Node2D

@onready var lasers = $Lasers
@onready var jugador = $Jugador
@onready var asteroides = $AsteroidesIniciales
@onready var hud = $UI/HUD
@onready var pantallaDeGameOver = $UI/MenuGameOver
@onready var zonaReaparicion = $ZonaDeReaparicion
@onready var areaDeSpawnDelJugador = $ZonaDeReaparicion/SpawnJugador

var escenaAsteroides = preload("res://scennes/asteroide.tscn")

var puntuacion := 0:
	set(value):
		puntuacion = value
		hud.puntuacion = puntuacion

var vidas: int:
	set(value):
		vidas = value
		hud.iniciarVidas(vidas)

func _ready() -> void:
	pantallaDeGameOver.visible = false
	puntuacion = 0
	vidas = 2
	jugador.connect("disparoLaser", _disparoJugador)
	jugador.connect("muerto", _jugadorMuerto)
	
	for asteroide in asteroides.get_children():
		asteroide.connect("explotar", _asteroideExplotado)
	
func _process(delta):
		if Input.is_action_just_pressed("reset"):
			get_tree().reload_current_scene()

func _disparoJugador(laser):
	$SonidoLaser.play()
	lasers.add_child(laser)

func _asteroideExplotado(posicion, tamaño, puntos):
	$SonidoGolpearAsteroide.play()
	puntuacion += puntos
	for i in range(2):
		match tamaño:
			asteroide.TamañosDeAsteroides.GRANDE:
				spawn_asteroides(posicion, asteroide.TamañosDeAsteroides.MEDIO)
			asteroide.TamañosDeAsteroides.MEDIO:
				spawn_asteroides(posicion, asteroide.TamañosDeAsteroides.PEQUEÑO)
			asteroide.TamañosDeAsteroides.PEQUEÑO:
				pass
	print(puntuacion)
		

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
	jugador.global_position = areaDeSpawnDelJugador.global_position
	print(vidas)
	if vidas <= 0:
		await get_tree().create_timer(2).timeout
		pantallaDeGameOver.visible = true
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
