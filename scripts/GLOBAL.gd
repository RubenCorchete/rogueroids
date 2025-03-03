extends Node

var version = 1.07
var save_path = "user://save_game.dat"
var jugando = false

var game_data : Dictionary = {
	"velocidadMaximaDeLaNave" : 250,
	"velocidadDeRotacion" : 200,
	"tiempoEntreDisparos" : 0.8,
	"vidasIniciales" : 1,
	"vidas" : 1,
	"version" : 1.07,
	"puntosInicio" : 0,
	"puntos" : 0,
	"Mejoras" : {
		"Mejora1" : 0,
		"Mejora2" : 0,
	},
	"Configuracion" : {
		"volumen" : 0.5,
		"resolucion" : Vector2i(1920, 1080),
		"pantallaCompleta" : true, 
	}
}

var default_game_data : Dictionary = {
	"velocidadMaximaDeLaNave" : 250,
	"velocidadDeRotacion" : 200,
	"tiempoEntreDisparos" : 0.8,
	"vidasIniciales" : 1,
	"version" : 1.07,
	"vidas" : 1,
	"puntos" : 0,
	"puntosInicio" : 0,
	"Mejoras" : {
		"Mejora1" : 0,
		"Mejora2" : 0,
	},
	"Configuracion" : {
		"volumen" : 0.5,
		"resolucion" : Vector2i(1920, 1080),
		"pantallaCompleta" : true, 
	}
}

# Getters
func get_volumen() -> float:
	return game_data.get("Configuracion").get("volumen")

func get_tiempo_entre_disparos() -> float:
	return game_data.get("tiempoEntreDisparos")

func get_velocidad_rotacion() -> int:
	return game_data.get("velocidadDeRotacion", 200)

func get_velocidad_maxima() -> int:
	return game_data.get("velocidadMaximaDeLaNave", 250)

func get_vidas() -> int:
	return game_data.get("vidas", 0)

func get_vidas_maximas() -> int:
	return game_data.get("vidasMaximas", 0)

func get_puntos() -> int:
	return game_data.get("puntos", 0)

func get_mejora(nombre: String) -> int:
	return game_data["Mejoras"].get(nombre, 0)

# Setters
func set_volumen(valor: float) -> void:
	game_data["Configuracion"]["volumen"] = valor

func set_tiempo_entre_disparos(valor: float) -> void:
	game_data["tiempoEntreDisparos"] = max(valor, 0)  # Evita valores negativos o cero

func set_velocidad_rotacion(valor: int) -> void:
	game_data["velocidadDeRotacion"] = max(valor, 0) # Evita valores negativos

func set_velocidad_maxima(valor: int) -> void:
	game_data["velocidadMaximaDeLaNave"] = max(valor, 0) # Evita valores negativos

func set_vidas(valor: int) -> void:
	game_data["vidas"] = max(valor, 0) # Evita valores negativos

func set_puntos(valor: int) -> void:
	game_data["puntos"] = max(valor, 0) # Evita valores negativos
	
func set_añadir_puntos(valor: int) -> void:
	game_data["puntos"] += max(valor, 0) # Evita valores negativos

func set_mejora(nombre: String, valor: int) -> void:
	if nombre in game_data["Mejoras"]:
		game_data["Mejoras"][nombre] = max(valor, 0) # Evita valores negativos

#Getters de los datos por defecto
func get_default_velocidad_maxima_nave() -> float:
	return default_game_data["velocidadMaximaDeLaNave"]

func get_default_velocidad_rotacion() -> float:
	return default_game_data["velocidadDeRotacion"]

func get_default_tiempo_entre_disparos() -> float:
	return default_game_data["tiempoEntreDisparos"]

func get_default_vidas_iniciales() -> int:
	return default_game_data["vidasIniciales"]

func get_default_version() -> float:
	return default_game_data["version"]

func get_default_vidas() -> int:
	return default_game_data["vidas"]

func get_default_puntos() -> int:
	return default_game_data["puntos"]

func get_default_puntos_inicio() -> int:
	return default_game_data["puntosInicio"]

# Mejoras
func get_default_mejora_1() -> int:
	return default_game_data["Mejoras"]["Mejora1"]

func get_default_mejora_2() -> int:
	return default_game_data["Mejoras"]["Mejora2"]

# Configuración
func get_default_volumen() -> float:
	return default_game_data["Configuracion"]["volumen"]

func get_default_resolucion() -> Vector2i:
	return default_game_data["Configuracion"]["resolucion"]

func get_default_pantalla_completa() -> bool:
	return default_game_data["Configuracion"]["pantallaCompleta"]
	
func get_resolucion() -> Vector2i:
	return game_data["Configuracion"]["resolucion"]

func set_resolucion(res: Vector2i) -> void:
	game_data["Configuracion"]["resolucion"] = res

# Getter y setter para la pantalla completa
func get_pantalla_completa() -> bool:
	return game_data["Configuracion"]["pantallaCompleta"]

func set_pantalla_completa(fullscreen: bool) -> void:
	game_data["Configuracion"]["pantallaCompleta"] = fullscreen

#Funciones creadas
func save_game() -> void:
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_var(game_data)
	save_file = null #Cerrar el archivo
	
func load_game() -> void:
	var save_file = FileAccess.open(save_path, FileAccess.READ)

	if FileAccess.file_exists(save_path):
		var versionArchivo = save_file.get_var()

		if versionArchivo.has("version") and versionArchivo["version"] == version:
			game_data = versionArchivo
	else:
		game_data = default_game_data
		
	save_file = null #Cerrar el archivo
	set_config()
	
func set_config():
	#Sonido
	var volumen = game_data.get("Configuracion", {}).get("volumen")
	AudioServer.set_bus_volume_db(0, linear_to_db(volumen))
	
	#Pantalla
	if get_pantalla_completa():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		DisplayServer.window_set_size(Vector2i(1920, 1080))
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(get_resolucion())

func reiniciar_partida():
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)

	# Verificar que default_game_data no sea null
	if default_game_data:
		var default_game_data_con_config = default_game_data.duplicate(true)

		# Verificar que game_data["configuracion"] exista antes de copiarlo
		if game_data.has("configuracion"):
			default_game_data_con_config["configuracion"] = game_data["configuracion"].duplicate(true)
		
		# Guardar los datos reiniciados
		save_file.store_var(default_game_data_con_config)
		save_file = null
		
	save_game()
	load_game()
