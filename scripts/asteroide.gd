class_name asteroide extends Area2D

# Señal que se emite cuando un assteroide explota
signal explotar(posicion, tamaño)

# Posición a la que se mueve el asteroide, hacia arriba inicialmente
var vectorDeMovimiento := Vector2(0,-1)

# Lista de los tamaños de asteroides
enum TamañosDeAsteroides{GRANDE, MEDIO, PEQUEÑO}

# Esta variable se usara para gestionar el tamaño del asteroide. Por defecto es grande
@export var size := TamañosDeAsteroides.GRANDE

# Esta variable se usara para gestionar la velocidad del asteroide. Por defecto es 200
var velocidad := 200

# Referencias al Sprite del Asteroide y a su zona de colisión
@onready var sprite = $Sprite2D
@onready var forma = $CollisionShape2D

# Puntos que da el asteroide en base a su tamaño
var puntos: int:
	get:
		match size:
			TamañosDeAsteroides.GRANDE:
				return 10
			TamañosDeAsteroides.MEDIO:
				return 15
			TamañosDeAsteroides.PEQUEÑO:
				return 20
			_:
				return 0

# _init se ejecuta cuando se instancia el nodo
func _init() -> void:
	size = obtener_tamaño_aleatorio() # Seleccionamos un tamaño aleatorio

# _ready se ejecuta cuando el nodo principal y los hijos aparecen en la escena
func _ready() -> void:

	# Le doy un angulo aleatorio para que salga moviendose aleatoriamente
	rotation = randf_range(0,2*PI)
	
	# Según el tamaño le asigno una velocidad y forma adecuada
	match size:
		TamañosDeAsteroides.GRANDE:
			velocidad = randf_range(50,100)
			sprite.texture = preload("res://assets/Enemigos/Asteroides/MeteoritoGrande.png")
			forma.shape = preload("res://recursos/asteroide_forma_grande.tres")
		TamañosDeAsteroides.MEDIO:
			velocidad = randf_range(100,150)
			sprite.texture = preload("res://assets/Enemigos/Asteroides/MeteoritoMedio.png")
			forma.shape = preload("res://recursos/asteroide_forma_medio.tres")
		TamañosDeAsteroides.PEQUEÑO:
			velocidad = randf_range(100,200)
			sprite.texture = preload("res://assets/Enemigos/Asteroides/MeteoritoPequeño.png")
			forma.shape = preload("res://recursos/asteroide_forma_pequeño.tres")

# _physics_process se ejecuta cada frame
func _physics_process(delta: float) -> void:
	# le asigno una posición y dirección en base a las variables generadas de manera aleatoria anteriormente
	global_position += vectorDeMovimiento.rotated(rotation) * velocidad * delta

	#Esta sección de código hace que el asteroide se teleporte al otro lado de la pantalla de abajo a arriba etc
	var radio = forma.shape.radius
	var tamanoPantalla = get_viewport_rect().size
	
	if global_position.y + radio < 0:
		global_position.y = tamanoPantalla.y + radio
	elif global_position.y - radio > tamanoPantalla.y:
		global_position.y = -radio
	
	if global_position.x + radio < 0: 
		global_position.x = tamanoPantalla.x + radio
	elif global_position.x - radio> tamanoPantalla.x: 
		global_position.x = - radio  

# Esta función es llamada cuando un asteroide explota. Manda la señal de que ha explotado y desaparece
func explosion():
	emit_signal("explotar", global_position, size, puntos)
	queue_free()

# Esta función detecta colisiones con el jugador y hace que el jugador muera y pierda una vida
func _on_body_entered(body: Node2D) -> void:
	if body is Jugador or Jugador2Cañones:
		var jugador = body 
		jugador.morir()

# Esta función selecciona uno 2 los 3 tamaños posibles de asteroides
func obtener_tamaño_aleatorio():
	var valores = TamañosDeAsteroides.values()
	return valores[randi() % valores.size()]
