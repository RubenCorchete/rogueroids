extends Control

#Referencias a las partes de la interfaz
@onready var selectorResolucion = $MarginContainer/VBoxContainer/Resolucion
@onready var checkBoxPantallaCompleta = $MarginContainer/VBoxContainer/PantallaCompleta
@onready var barraVolumen = $MarginContainer/VBoxContainer/Volumen

# Variable para guardar la referencia al menú principal
var menuPrincipal = null
func obtener_menu_principal(menu):
	menuPrincipal = menu

# Se actualizan los valores visuales de la interfaz
func _ready() -> void:
	await get_tree().process_frame
	actualizarBarra()
	actualizarResolucionYPantallaCompleta()
	
# SONIDO
func _on_volumen_value_changed(value: float) -> void:
	GameSettings.set_volumen(value)  # Guarda el volumen
	AudioServer.set_bus_volume_db(0, linear_to_db(value)) # Ajusta el volumen real del juego

# Actualiza visualmente la barra con el valor guardado
func actualizarBarra():
	barraVolumen.set_value(GameSettings.get_volumen())

#PANTALLA
# Cambia la resolución según la opción seleccionada en el menú desplegable
func _on_resolucion_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
			GameSettings.set_resolucion(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
			GameSettings.set_resolucion(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1440, 810))  
			GameSettings.set_resolucion(Vector2i(1440, 810))

# Alterna entre pantalla completa y modo ventana
func _on_pantalla_completa_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GameSettings.set_pantalla_completa(true)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		selectorResolucion.disabled = true
	else:
		GameSettings.set_pantalla_completa(false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(1920, 1080))
		selectorResolucion.disabled = false
	actualizarResolucionYPantallaCompleta()

# Actualiza los valores visuales del checkbox y selector de resolución según lo que haya guardado		
func actualizarResolucionYPantallaCompleta():
	if GameSettings.get_pantalla_completa():
		checkBoxPantallaCompleta.set_pressed(true)
	else:
		checkBoxPantallaCompleta.set_pressed(false) 
		
	var resolucion = GameSettings.get_resolucion()
	
	match resolucion:
		Vector2i(1920, 1080):
			selectorResolucion.select(0)
		Vector2i(1600, 900):
			selectorResolucion.select(1)
		Vector2i(1440, 810):
			selectorResolucion.select(2)

# Restaura los valores predeterminados de sonido y pantalla
func _on_boton_de_resetear_pressed() -> void:
	GameSettings.reset_game_settings()
	actualizarResolucionYPantallaCompleta()
	actualizarBarra()

# Cierra el menú de opciones y vuelve al menú principal
func _on_boton_de_salir_pressed() -> void:
	visible = false
	menuPrincipal.visible = true
	GameSettings.set_config()

# Si se sale de manera inesperada se guarda los ultimos valores seleccionados
func _exit_tree() -> void:
	GameSettings.save_settings()
