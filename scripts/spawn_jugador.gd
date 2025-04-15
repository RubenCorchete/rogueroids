extends Area2D

# Variable booleana que indica si el área está vacía (sin cuerpos ni otras áreas superpuestas)
var estaVacio: bool:
	get:
		# Devuelve true si NO hay áreas ni cuerpos superpuestos, es decir, si está completamente libre
		return (!has_overlapping_areas() && !has_overlapping_bodies())

#Esta función es llamada cuando el jugador muere y le quedan vidas extra. Limpia la zona de reaparición de enemigos para que no insta muera al aparecer de nuevo
func controlLimpiezaZonaReaparicion():
	for objeto in $".".get_overlapping_areas():
		objeto.queue_free()
