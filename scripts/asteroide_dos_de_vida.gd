# Declaramos la clase con nombre global (usable en el editor)
class_name asteroideDosDeVida extends Area2D

# Señal que se emitirá al explotar el asteroide
signal explotar(posicion, tamaño, puntos)

# Variables exportadas para modificar desde el editor
@export var size: TamañosDeAsteroides
@export var escenaAsteroide: PackedScene

# Variables de comportamiento
var velocidad := 200
var vida = 2
var vectorDeMovimiento := Vector2(0, -1)  # Dirección inicial hacia arriba

# Enumeración con los tamaños posibles
enum TamañosDeAsteroides {GRANDE, MEDIO, PEQUEÑO}

# Referencias a nodos del árbol
@onready var sprite = $Sprite2D
@onready var forma = $CollisionShape2D

# Diccionario que asocia cada tamaño con su textura normal
const TEXTURAS := {
	TamañosDeAsteroides.GRANDE: preload("res://assets/Enemigos/Asteroides/MeteoritoGrandeGris.png"),
	TamañosDeAsteroides.MEDIO: preload("res://assets/Enemigos/Asteroides/MeteoritoMedioGris.png"),
	TamañosDeAsteroides.PEQUEÑO: preload("res://assets/Enemigos/Asteroides/MeteoritoPequeñoGris.png")
}

# Diccionario con las texturas cuando el asteroide es golpeado
const TEXTURAS_GOLPEADO := {
	TamañosDeAsteroides.GRANDE: preload("res://assets/Enemigos/Asteroides/MeteoritoGrandeGrisGolpeado.png"),
	TamañosDeAsteroides.MEDIO: preload("res://assets/Enemigos/Asteroides/MeteoritoMedioGrisGolpeado.png"),
	TamañosDeAsteroides.PEQUEÑO: preload("res://assets/Enemigos/Asteroides/MeteoritoPequeñoGrisGolpeado.png")
}

# Diccionario con las formas de colisión por tamaño
const FORMAS := {
	TamañosDeAsteroides.GRANDE: preload("res://recursos/asteroide_forma_grande.tres"),
	TamañosDeAsteroides.MEDIO: preload("res://recursos/asteroide_forma_medio.tres"),
	TamañosDeAsteroides.PEQUEÑO: preload("res://recursos/asteroide_forma_pequeño.tres")
}

# Propiedad que devuelve los puntos que da el asteroide según su tamaño
var puntos: int:
	get:
		match size:
			TamañosDeAsteroides.GRANDE: return 30
			TamañosDeAsteroides.MEDIO: return 45
			TamañosDeAsteroides.PEQUEÑO: return 60
			_: return 0

# Función que se ejecuta al instanciar el nodo
func _ready() -> void:
	vida = 2
	size = obtener_tamaño_aleatorio()
	rotation = randf_range(0, 2 * PI)  # Rotación aleatoria

	# Asignamos velocidad según el tamaño
	match size:
		TamañosDeAsteroides.GRANDE:
			velocidad = randf_range(50, 100)
		TamañosDeAsteroides.MEDIO:
			velocidad = randf_range(100, 150)
		TamañosDeAsteroides.PEQUEÑO:
			velocidad = randf_range(100, 200)

	# Aplicamos textura y forma correspondientes desde los diccionarios
	sprite.texture = TEXTURAS[size]
	forma.shape = FORMAS[size]

# Función que devuelve un tamaño aleatorio de los posibles
func obtener_tamaño_aleatorio():
	var valores = TamañosDeAsteroides.values()
	return valores[randi() % valores.size()]

# Movimiento continuo y control de pantalla
func _physics_process(delta: float) -> void:
	global_position += vectorDeMovimiento.rotated(rotation) * velocidad * delta

	var radio = forma.shape.radius
	var tamanoPantalla = get_viewport_rect().size

	# Teletransporte en los bordes de la pantalla
	if global_position.y + radio < 0:
		global_position.y = tamanoPantalla.y + radio
	elif global_position.y - radio > tamanoPantalla.y:
		global_position.y = -radio

	if global_position.x + radio < 0:
		global_position.x = tamanoPantalla.x + radio
	elif global_position.x - radio > tamanoPantalla.x:
		global_position.x = -radio

# Función que se llama cuando el asteroide recibe un golpe
func asteroideGolpeado():
	vida -= 1
	if vida <= 0:
		explosion()
	else:
		# Efecto de golpe visual (parpadeo rojo)
		modulate = Color(1, 0.5, 0.5)
		await get_tree().create_timer(0.1).timeout
		modulate = Color(1, 1, 1)

		# Cambia la textura a la de "golpeado"
		sprite.texture = TEXTURAS_GOLPEADO[size]

# Función que gestiona la explosión del asteroide
func explosion():
	match size:
		TamañosDeAsteroides.GRANDE:
			sprite.texture = TEXTURAS_GOLPEADO[TamañosDeAsteroides.MEDIO]
			size = TamañosDeAsteroides.MEDIO

		TamañosDeAsteroides.MEDIO:
			sprite.texture = TEXTURAS_GOLPEADO[TamañosDeAsteroides.PEQUEÑO]
			size = TamañosDeAsteroides.PEQUEÑO

		TamañosDeAsteroides.PEQUEÑO:
			# En el más pequeño, emitimos señal y destruimos
			emit_signal("explotar", global_position, size, puntos)
			queue_free()

# Crea una nueva instancia de asteroide con un tamaño menor
func crear_fragmento(nuevo_tamaño):
	if escenaAsteroide == null:
		return
	var nuevo = escenaAsteroide.instantiate()
	nuevo.size = TamañosDeAsteroides[nuevo_tamaño]
	nuevo.escenaAsteroide = escenaAsteroide
	nuevo.global_position = global_position
	get_parent().add_child(nuevo)

# Reacción al colisionar con el jugador
func _on_body_entered(body: Node2D) -> void:
	if body is Jugador or Jugador2Cañones:
		body.morir()
