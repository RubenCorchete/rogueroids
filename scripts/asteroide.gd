class_name asteroide extends Area2D

signal explotar(posicion, tamaño)

var vectorDeMovimiento := Vector2(0,-1)

enum TamañosDeAsteroides{GRANDE, MEDIO, PEQUEÑO}

@export var size := TamañosDeAsteroides.GRANDE
var velocidad := 200

@onready var sprite = $Sprite2D
@onready var forma = $CollisionShape2D

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

# Referencia a la escena del asteroide (para instanciar desde sí mismo)
var escenaAsteroide := preload("res://scennes/asteroide.tscn")

func _init() -> void:
	size = obtener_tamaño_aleatorio()

func _ready() -> void:
	rotation = randf_range(0,2*PI)
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

func _physics_process(delta: float) -> void:
	global_position += vectorDeMovimiento.rotated(rotation) * velocidad * delta

	var radio = forma.shape.radius
	var tamanoPantalla = get_viewport_rect().size

	if global_position.y + radio < 0:
		global_position.y = tamanoPantalla.y + radio
	elif global_position.y - radio > tamanoPantalla.y:
		global_position.y = -radio

	if global_position.x + radio < 0: 
		global_position.x = tamanoPantalla.x + radio
	elif global_position.x - radio > tamanoPantalla.x: 
		global_position.x = - radio  

func explosion():
	emit_signal("explotar", global_position, size, puntos)

	# Crear asteroides más pequeños si corresponde
	if size != TamañosDeAsteroides.PEQUEÑO:
		var nuevo_tamaño = size + 1  # Porque el enum está en orden: GRANDE = 0, MEDIO = 1, PEQUEÑO = 2
		for i in range(2):
			var a = escenaAsteroide.instantiate()
			a.global_position = self.global_position
			a.size = nuevo_tamaño
			a.rotation = randf_range(0, 2*PI)
			a.vectorDeMovimiento = Vector2(0, -1).rotated(a.rotation)
			get_parent().add_child(a)
			
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Jugador or Jugador2Cañones:
		var jugador = body 
		jugador.morir()

func obtener_tamaño_aleatorio():
	var valores = TamañosDeAsteroides.values()
	return valores[randi() % valores.size()]
