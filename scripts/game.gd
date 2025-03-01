extends Node2D

@onready var lasers = $Lasers
@onready var jugador = $Jugador
@onready var asteroides = $Asteroides

var escenaAsteroides = preload("res://scennes/asteroide.tscn")

func _ready() -> void:
	jugador.connect("disparoLaser", _disparoJugador)
	
	for asteroide in asteroides.get_children():
		asteroide.connect("explotar", _asteroideExplotado)
	
func _process(delta):
		if Input.is_action_just_pressed("reset"):
			get_tree().reload_current_scene()

func _disparoJugador(laser):
	lasers.add_child(laser)

func _asteroideExplotado(posicion, tamaño):
	for i in range(2):
		match tamaño:
			asteroide.TamañosDeAsteroides.GRANDE:
				spawn_asteroides(posicion, asteroide.TamañosDeAsteroides.MEDIO)
			asteroide.TamañosDeAsteroides.MEDIO:
				spawn_asteroides(posicion, asteroide.TamañosDeAsteroides.PEQUEÑO)
			asteroide.TamañosDeAsteroides.PEQUEÑO:
				pass
		

func spawn_asteroides(pos, size):
	var a = escenaAsteroides.instantiate()
	a.global_position = pos
	a.size = size
	a.connect("explotar", _asteroideExplotado)
	asteroides.call_deferred("add_child", a)
