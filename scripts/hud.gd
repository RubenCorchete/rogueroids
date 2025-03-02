extends Control

@onready var vidas = $Vidas
@onready var puntuacion = $Puntuacion:
	set(value):
		puntuacion.text = "SCORE: " + str(value)

var uiEscena = preload("res://scennes/ui_vidas.tscn")


func cambiarScore(cantidad):
	puntuacion.text = "SCORE: " + str(cantidad)

func iniciarVidas(cantidad):
	for ul in vidas.get_children():
		ul.queue_free()
		
	for i in cantidad:
		var ul = uiEscena.instantiate()
		vidas.add_child(ul)
