# Script del HUD principal. Controla la visualización de las vidas y la puntuación.
extends Control

# Contenedor de vidas
@onready var vidas = $Vidas

# Etiqueta que muestra la puntuación del jugador.
@onready var puntuacion = $Puntuacion:
	set(value):
		puntuacion.text = "SCORE: " + str(value)

var uiEscena = preload("res://scennes/ui_vidas.tscn")

# Esta función cambia la puntuación mostrada
func cambiarScore(cantidad):
	puntuacion.text = "SCORE: " + str(cantidad)

# Actualiza las vidas mostradas
func iniciarVidas(cantidad):
	for ul in vidas.get_children():
		ul.queue_free()
		
	for i in cantidad:
		var ul = uiEscena.instantiate()
		vidas.add_child(ul)
