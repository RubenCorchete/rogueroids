extends Area2D

# Variable booleana que indica si el área está vacía (sin cuerpos ni otras áreas superpuestas)
var estaVacio: bool:
	get:
		# Devuelve true si NO hay áreas ni cuerpos superpuestos, es decir, si está completamente libre
		return (!has_overlapping_areas() && !has_overlapping_bodies())

var muerto = false

func controlLimpiezaZonaReaparicion():
	!muerto

func _limpiar_zona_spawn(area: Area2D) -> void:
	if muerto:
		if area is naveEnemiga or area is asteroide:
			area.queue_free()
