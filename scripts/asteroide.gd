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

func _ready() -> void:
	rotation = randf_range(0,2*PI)
	
	#Elegir que asteroide aparece de manera aleatoria
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
	elif global_position.x - radio> tamanoPantalla.x: 
		global_position.x = - radio  

func explosion():
	emit_signal("explotar", global_position, size, puntos)
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Jugador:
		var jugador = body 
		jugador.morir()
