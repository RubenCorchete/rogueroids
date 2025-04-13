class_name menu extends Control

@onready var menuAjustes = $MenuDeAjustes
@onready var menuPrincipal = $MenuPrincipal
@onready var menuCompra = $TiendaDeObjetos

func _on_boton_de_inicio_pressed() -> void:
	GLOBAL.jugando = true
	get_tree().reload_current_scene()

func _on_boton_de_salir_pressed() -> void:
	GLOBAL.save_game()
	get_tree().quit()

func _on_boton_de_compra_pressed() -> void:
	menuCompra.obtener_menu_principal(menuPrincipal)
	menuPrincipal.visible = false
	menuCompra.visible = true

func _on_boton_de_restart_partida_pressed() -> void:
	GLOBAL.reiniciar_partida()
	get_parent().get_parent().actualizarPuntuacionVidasReinicio() #Obtener escena game
	
	
func _on_boton_de_ajustes_pressed() -> void:
	menuAjustes.obtener_menu_principal(menuPrincipal)
	menuPrincipal.visible = false
	menuAjustes.visible = true
	
