class_name menu extends Control

var escena = preload("res://scennes/game.tscn")

func _on_boton_de_inicio_pressed() -> void:
	GLOBAL.jugando = true
	get_tree().reload_current_scene()

func _on_boton_de_salir_pressed() -> void:
	GLOBAL.save_game()
	get_tree().quit()


func _on_boton_de_compra_pressed() -> void:
	pass # Replace with function body.


func _on_boton_de_restart_partida_pressed() -> void:
	GLOBAL.reiniciar_partida()
	get_parent().get_parent().actualizarPuntuacionVidas() #Obtener escena game
	
