extends Node

# Ruta del archivo donde se guardan las configuraciones
const SAVE_PATH = "user://save_settings.dat"

# Configuración por defecto
var default_game_settings : Dictionary = {
	"volumen": 0.5 ,  # Volumen inicial
	"resolucion": Vector2i(1920, 1080),  # Resolución inicial
	"pantallaCompleta": true  # Pantalla completa por defecto
}

# Diccionario para almacenar la configuración del usuario
var user_game_settings : Dictionary

# Al iniciar la escena, cargamos la configuración del juego
func _ready() -> void:
	load_game()

# Función para cargar la configuración guardada
func load_game() -> void:
	# Verificamos si el archivo de configuración existe
	if FileAccess.file_exists(SAVE_PATH):
		# Abrimos el archivo en modo lectura
		var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		# Leemos la configuración guardada en el archivo
		user_game_settings = save_file.get_var()
		save_file = null
	else:
		# Si no existe el archivo, usamos la configuración por defecto
		user_game_settings = default_game_settings.duplicate(true)

	# Aplicamos la configuración cargada o por defecto
	set_config()

# Función para guardar la configuración del usuario en un archivo
func save_settings() -> void:
	# Abrimos el archivo en modo escritura
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	# Guardamos la configuración actual en el archivo
	save_file.store_var(user_game_settings)
	save_file = null

# Función para restablecer la configuración a los valores por defecto
func reset_game_settings() -> void:
	# Restablecemos la configuración a los valores por defecto
	user_game_settings = default_game_settings.duplicate(true)
	# Guardamos la nueva configuración
	save_settings()
	# Aplicamos los nuevos valores de configuración
	set_config()

# Función para aplicar la configuración guardada
func set_config():
	# Aplicamos el volumen configurado
	AudioServer.set_bus_volume_db(0, linear_to_db(get_volumen()))

	# Aplicamos el modo de pantalla (completa o ventana)
	if get_pantalla_completa():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	# Si no está en pantalla completa, ajustamos la resolución
	if not get_pantalla_completa():
		DisplayServer.window_set_size(get_resolucion())

# Getters y Setters para el diccionario

# Getter para el volumen
func get_volumen() -> float:
	return user_game_settings.get("volumen", 0.5)

# Setter para el volumen
func set_volumen(valor : float) -> void:
	user_game_settings["volumen"] = valor

# Getter para la resolución
func get_resolucion() -> Vector2i:
	return user_game_settings.get("resolucion", Vector2i(1920, 1080))

# Setter para la resolución
func set_resolucion(valor : Vector2i) -> void:
	user_game_settings["resolucion"] = valor

# Getter para la pantalla completa
func get_pantalla_completa() -> bool:
	return user_game_settings.get("pantallaCompleta", true)

# Setter para la pantalla completa
func set_pantalla_completa(valor : bool) -> void:
	user_game_settings["pantallaCompleta"] = valor
