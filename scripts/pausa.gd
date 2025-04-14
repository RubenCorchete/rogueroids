# Script para el menú de pausa
extends CanvasLayer

# Variable para controlar si el menú de pausa está visible o no
var menuVisible = false

func _process(delta: float) -> void:
		# Detectamos si se presiona la tecla de pausa "Esc"
	if Input.is_action_just_pressed("pausa") and GLOBAL.jugando:
		if !menuVisible:
			# Si el menú no está visible, lo mostramos
			menuVisible = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE # Mostramos el cursor del ratón
		else:
			# Si el menú ya está visible, lo ocultamos
			menuVisible = false
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN  # Ocultamos el cursor del ratón
		pausar()

# Botón "Continuar" del menú de pausa
func _on_button_continuar_pressed() -> void:
	pausar()
	menuVisible = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN # Ocultamos el ratón

# Botón "Salir al menú" del menú de pausa
func _on_button_salir_pressed() -> void:
	get_parent().mostrarMenuPrincipalAlMorir()
	GLOBAL.save_game()
	pausar()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	menuVisible = false

# Función para pausar y reanudar el juego
func pausar():
	get_tree().paused = not get_tree().paused # Cambiamos el estado de pausa del juego
	$ColorRect.visible = not $ColorRect.visible # Mostramos u ocultamos el fondo del menú
	$Titulo.visible = not $Titulo.visible # Mostramos u ocultamos el título del menú
	$VBoxContainer.visible = not $VBoxContainer.visible # Mostramos u ocultamos los botones del menú
