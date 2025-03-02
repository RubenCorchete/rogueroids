extends Node

var version = 1.02
var save_path = "user://save_game.dat"
var jugando = false

var game_data : Dictionary = {
	"velocidadMaximaDeLaNave" : 250,
	"velocidadDeRotacion" : 200,
	"tiempoEntreDisparos" : 0.8,
	"vidasIniciales" : 1,
	"vidas" : 1,
	"version" : 1.01,
	"puntosInicio" : 0,
	"puntos" : 0,
	"Mejoras" : {
		"Mejora1" : 0,
		"Mejora2" : 0,
	}
}

var default_game_data : Dictionary = {
	"velocidadMaximaDeLaNave" : 250,
	"velocidadDeRotacion" : 200,
	"tiempoEntreDisparos" : 0.8,
	"vidasIniciales" : 1,
	"version" : 1.01,
	"vidas" : 1,
	"puntos" : 0,
	"puntosInicio" : 0,
	"Mejoras" : {
		"Mejora1" : 0,
		"Mejora2" : 0,
	}
}

func reiniciar_partida():
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_var(default_game_data)
	save_file = null
	
	load_game()

# Getters
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

func save_game() -> void:
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_var(game_data)
	save_file = null #Cerrar el archivo
	
func load_game() -> void:
	var save_file = FileAccess.open(save_path, FileAccess.READ)

	if FileAccess.file_exists(save_path):
		var versionArchivo = save_file.get_var()
		print(versionArchivo.has("version"))
		
		if versionArchivo.has("version") and versionArchivo["version"] == version:
			game_data = versionArchivo
	else:
		game_data = default_game_data
		
	save_file = null #Cerrar el archivo
