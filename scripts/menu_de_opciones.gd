extends Control

@onready var selectorResolucion = $MarginContainer/VBoxContainer/Resolucion
@onready var checkBoxPantallaCompleta = $MarginContainer/VBoxContainer/PantallaCompleta
@onready var barraVolumen = $MarginContainer/VBoxContainer/Volumen

var menuPrincipal = null
func obtener_menu_principal(menu):
	menuPrincipal = menu
	
func _ready() -> void:
	await get_tree().process_frame
	actualizarBarra()
	actualizarResolucionYPantallaCompleta()
	
# Sonido
func _on_volumen_value_changed(value: float) -> void:
	GLOBAL.set_volumen(value)
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func actualizarBarra():
	barraVolumen.set_value(GLOBAL.get_volumen())

#Pantalla
func _on_resolucion_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
			GLOBAL.set_resolucion(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
			GLOBAL.set_resolucion(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1440, 810))  
			GLOBAL.set_resolucion(Vector2i(1440, 810))

func _on_pantalla_completa_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GLOBAL.set_pantalla_completa(true)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		selectorResolucion.disabled = true
	else:
		GLOBAL.set_pantalla_completa(false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(1920, 1080))
		selectorResolucion.disabled = false
	actualizarResolucionYPantallaCompleta()
		
func actualizarResolucionYPantallaCompleta():
	if GLOBAL.get_pantalla_completa():
		checkBoxPantallaCompleta.set_pressed(true)
	else:
		checkBoxPantallaCompleta.set_pressed(false) 
		
	var resolucion = GLOBAL.get_resolucion()
	
	match resolucion:
		Vector2i(1920, 1080):
			selectorResolucion.select(0)
		Vector2i(1600, 900):
			selectorResolucion.select(1)
		Vector2i(1440, 810):
			selectorResolucion.select(2)

func _on_boton_de_resetear_pressed() -> void:
	#Audio
	GLOBAL.set_volumen(GLOBAL.get_default_volumen())
	actualizarBarra()
	
	#Video
	GLOBAL.set_resolucion(GLOBAL.get_default_resolucion())
	GLOBAL.set_pantalla_completa(GLOBAL.get_default_pantalla_completa())
	GLOBAL.set_config()
	actualizarResolucionYPantallaCompleta()

func _on_boton_de_salir_pressed() -> void:
	visible = false
	menuPrincipal.visible = true
	GLOBAL.set_config()

func _exit_tree() -> void:
	GLOBAL.save_game()
