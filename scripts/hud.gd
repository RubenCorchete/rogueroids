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
	var vidas_actuales = vidas.get_children()
	var cantidad_actual = vidas_actuales.size()

	if cantidad == cantidad_actual:
		return  # No hacer nada si ya están bien

	elif cantidad < cantidad_actual:
		# Eliminar las vidas sobrantes (empezando desde el final)
		for i in range(cantidad_actual - 1, cantidad - 1, -1):
			vidas_actuales[i].queue_free()

	else:
		# Agregar las vidas que faltan
		var vidas_a_agregar = cantidad - cantidad_actual
		for i in range(vidas_a_agregar):
			var nueva_vida = uiEscena.instantiate()
			vidas.add_child(nueva_vida)
