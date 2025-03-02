extends Node

var save_path = "user://save_game.dat"

var game_data : Dictionary = {
	"velocidadMaximaDeLaNave" : 250,
	"velocidadDeRotacion" : 200,
	"vidas" : 3,
	"puntos" : 0,
	
	"Mejoras" : {
		"Mejora1" : 1,
		"Mejora2" : 1,
	}
}

# Getters
func get_velocidad_rotacion() -> int:
	return game_data.get("velocidadDeRotacion", 200)

func get_velocidad_maxima() -> int:
	return game_data.get("velocidadMaximaDeLaNave", 250)

func get_vidas() -> int:
	return game_data.get("vidas", 0)

func get_puntos() -> int:
	return game_data.get("puntos", 0)

func get_mejora(nombre: String) -> int:
	return game_data["Mejoras"].get(nombre, 0)

# Setters
func set_velocidad_rotacion(valor: int) -> void:
	game_data["velocidadDeRotacion"] = max(valor, 0) # Evita valores negativos

func set_velocidad_maxima(valor: int) -> void:
	game_data["velocidadMaximaDeLaNave"] = max(valor, 0) # Evita valores negativos

func set_vidas(valor: int) -> void:
	game_data["vidas"] = max(valor, 0) # Evita valores negativos

func set_puntos(valor: int) -> void:
	game_data["puntos"] = max(valor, 0) # Evita valores negativos

func set_mejora(nombre: String, valor: int) -> void:
	if nombre in game_data["Mejoras"]:
		game_data["Mejoras"][nombre] = max(valor, 0) # Evita valores negativos

func save_game() -> void:
	
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	print(save_path)
	save_file.store_var(game_data)
	save_file = null #Cerrar el archivo
	
func load_game() -> void:
	if FileAccess.file_exists(save_path):
		var save_file = FileAccess.open(save_path, FileAccess.READ)
		
		game_data = save_file.get_var()
		save_file = null #Cerrar el archivo
