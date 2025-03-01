extends Control

func _on_boton_de_reinicio_pressed() -> void:
	get_tree().reload_current_scene()
