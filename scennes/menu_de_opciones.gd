extends Control

var menuPrincipal = null
var volumen = GLOBAL.get_volumen()

func _ready() -> void:
	print(volumen)
	print($MarginContainer/VBoxContainer/Volumen.value)
	$MarginContainer/VBoxContainer/Volumen.value = volumen
	print($MarginContainer/VBoxContainer/Volumen.value)
func _on_boton_de_salir_pressed() -> void:
	visible = false
	menuPrincipal.visible = true
	GLOBAL.set_config()

func obtener_menu_principal(menu):
	menuPrincipal = menu

func _on_volumen_value_changed(value: float) -> void:

	GLOBAL.set_volumen(value)
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func _exit_tree() -> void:
	GLOBAL.set_config()
