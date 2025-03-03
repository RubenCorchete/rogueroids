extends Area2D

var vectorDeMovimiento := Vector2(0, -1)
@export var velocidad := 500.0

func _physics_process(delta):
	global_position += vectorDeMovimiento.rotated(rotation) * velocidad * delta
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is asteroide:
		var asteroid = area
		asteroid.explosion()
		queue_free()
