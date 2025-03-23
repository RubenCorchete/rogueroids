extends CanvasLayer
var menuVisible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pausa") and GLOBAL.jugando:
		if !menuVisible:
			menuVisible = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			menuVisible = false
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		pausar()

func _on_button_continuar_pressed() -> void:
	pausar()
	menuVisible = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _on_button_salir_pressed() -> void:
	get_parent().mostrarMenuPrincipalAlMorir()
	GLOBAL.save_game()
	pausar()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	menuVisible = false

func pausar():
	get_tree().paused = not get_tree().paused
	$ColorRect.visible = not $ColorRect.visible
	$Titulo.visible = not $Titulo.visible
	$VBoxContainer.visible = not $VBoxContainer.visible
