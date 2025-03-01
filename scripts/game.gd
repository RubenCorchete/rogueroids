extends Node2D

@onready var lasers = $Lasers
@onready var jugador = $Jugador

func _ready() -> void:
	jugador.connect("disparoLaser", _disparoJugador)

func _disparoJugador(laser):
	lasers.add_child(laser)
