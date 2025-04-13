extends Control

var menuPrincipal = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame

func obtener_menu_principal(menu):
	menuPrincipal = menu

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_boton_de_salir_pressed() -> void:
	visible = false
	menuPrincipal.visible = true
	GLOBAL.set_config()
