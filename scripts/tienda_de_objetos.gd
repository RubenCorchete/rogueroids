extends Control

# Variables para almacenar el menú principal y la lista de mejoras
var menuPrincipal = null
var listaBotonesMejoras

var referencia_a_game  # Aquí guardamos la referencia que viene desde arriba

# Botones de las mejoras disponibles en la UI
@onready var VelocidadDeDisparo = $HBoxContainer/ButtonMejoraVelocidadDisparo
@onready var AddVida = $HBoxContainer/ButtonMejoraAddVida
@onready var AddDosCañones = $"HBoxContainer/ButtonMejoraCañones"

func _ready() -> void:
	# Espera un frame antes de ejecutar la siguiente lógica
	await get_tree().process_frame
	# Llama a la función que comprueba las mejoras disponibles
	comprobarMejorasDisponibles()

# Función para obtener una referencia al menú principal desde otra escena
func obtener_menu_principal(menu):
	menuPrincipal = menu

# Función que se ejecuta cuando el botón de salir es presionado
func _on_boton_de_salir_pressed() -> void:
	visible = false
	menuPrincipal.visible = true
	GLOBAL.save_game()
	GLOBAL.load_game()

# Función que se ejecuta cuando el botón de mejora de velocidad de disparo es presionado
func _on_button_mejora_velocidad_disparo_button_up() -> void:
	GLOBAL.set_mejora_velocidad_de_disparo()
	VelocidadDeDisparo.disabled = true
	referencia_a_game.actualizar_hud_score()
	
# Función que se ejecuta cuando el botón de añadir vida es presionado
func _on_button_mejora_add_vida_button_up() -> void:
	GLOBAL.set_mejora_add_vidas()
	AddVida.disabled = true
	referencia_a_game.actualizar_hud_score()
	referencia_a_game.actualizar_hud_vidas()

# Función que se ejecuta cuando el botón de mejora de cañones es presionado	
func _on_button_mejora_cañones_button_up() -> void:
	GLOBAL.set_mejora_dos_cañones()
	AddDosCañones.disabled = true
	referencia_a_game.actualizar_hud_score()

# Función que comprueba qué mejoras están disponibles para ser adquiridas
func comprobarMejorasDisponibles():
	var mejorasDisponibles = GLOBAL.obtenerMejoras()
	for mejora in mejorasDisponibles:
		match mejora:
			"VelocidadDeDisparo":
				# Si la mejora está disponible y no está activada, habilita el botón correspondiente
				if comprobarSiHaySuficientesPuntos(mejorasDisponibles, mejora) and mejorasDisponibles[mejora]["activa"] != true:
					habilitarBoton(VelocidadDeDisparo)
			"AddVida":
				# Si la mejora está disponible y no está activada, habilita el botón correspondiente
				if comprobarSiHaySuficientesPuntos(mejorasDisponibles, mejora) and mejorasDisponibles[mejora]["activa"] != true:
					habilitarBoton(AddVida)
			"DobleCañon":
				# Si la mejora está disponible y no está activada, habilita el botón correspondiente
				if comprobarSiHaySuficientesPuntos(mejorasDisponibles, mejora) and mejorasDisponibles[mejora]["activa"] != true:
					habilitarBoton(AddDosCañones)

# Función que habilita un botón (desactiva su estado de "disabled")
func habilitarBoton(boton: Button):
		boton.disabled = false

# Función que comprueba si el jugador tiene suficientes puntos para comprar una mejora
func comprobarSiHaySuficientesPuntos(lista : Dictionary, nombreMejora : String) -> bool:
	for mejora in lista:
		if mejora == nombreMejora:
			if lista[mejora]["coste"] <= GLOBAL.get_puntos():
				return true
	return false
