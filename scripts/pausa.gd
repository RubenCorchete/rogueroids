extends CanvasLayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pausa") and GLOBAL.jugando:
		pausar()

func _on_button_continuar_pressed() -> void:
	pausar()

func _on_button_salir_pressed() -> void:
	get_parent().mostrarMenuPrincipalAlMorir()
	GLOBAL.save_game()
	pausar()

func pausar():
	get_tree().paused = not get_tree().paused
	$ColorRect.visible = not $ColorRect.visible
	$Titulo.visible = not $Titulo.visible
	$VBoxContainer.visible = not $VBoxContainer.visible
