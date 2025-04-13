extends Control

var menuPrincipal = null
var listaBotonesMejoras

var referencia_a_game  # Aquí guardamos la referencia que viene desde arriba

@onready var VelocidadDeDisparo = $VBoxContainer/HBoxContainer/ButtonMejoraVelocidadDisparo
@onready var AddVida = $VBoxContainer/HBoxContainer/ButtonMejoraAddVida

func _ready() -> void:
	await get_tree().process_frame
	comprobarMejorasDisponibles()

func obtener_menu_principal(menu):
	menuPrincipal = menu

func _on_boton_de_salir_pressed() -> void:
	visible = false
	menuPrincipal.visible = true
	GLOBAL.save_game()
	GLOBAL.load_game()

func _on_button_mejora_velocidad_disparo_button_up() -> void:
	GLOBAL.set_mejora_velocidad_de_disparo()
	VelocidadDeDisparo.disabled = true
	referencia_a_game.actualizar_hud()
	
func _on_button_mejora_add_vida_button_up() -> void:
	GLOBAL.set_mejora_add_vidas()
	AddVida.disabled = true
	referencia_a_game.actualizar_hud()

func comprobarMejorasDisponibles():
	var mejorasDisponibles = GLOBAL.obtenerMejoras()
	for mejora in mejorasDisponibles:
			
		match mejora:
			"VelocidadDeDisparo":
				if comprobarSiHaySuficientesPuntos(mejorasDisponibles, mejora) and mejorasDisponibles[mejora]["activa"] != true:
					habilitarBoton(VelocidadDeDisparo)
			"AddVida":
				if comprobarSiHaySuficientesPuntos(mejorasDisponibles, mejora) and mejorasDisponibles[mejora]["activa"] != true:
					habilitarBoton(AddVida)

func habilitarBoton(boton: Button):
		boton.disabled = false

func comprobarSiHaySuficientesPuntos(lista : Dictionary, nombreMejora : String) -> bool:
	
	for mejora in lista:
		if mejora == nombreMejora:
			if lista[mejora]["coste"] <= GLOBAL.get_puntos():
				return true
	return false
