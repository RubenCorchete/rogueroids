class_name naveEnemiga extends Area2D

# Señal que se emite cuando un assteroide explota
signal desaparecer(puntos)

# Posición a la que se mueve el asteroide, hacia arriba inicialmente
var vectorDeMovimiento := Vector2(0,-1)

# Esta variable se usara para gestionar la velocidad del asteroide. Por defecto es 200
var velocidad := 400

# Referencias al Sprite del Asteroide y a su zona de colisión
@onready var sprite = $Sprite2D
@onready var forma = $CollisionShape2D

# Puntos
var puntos = 150
var direccion = Vector2.ZERO

func iniciar_direccion(posicionObjetivo: Vector2):
	direccion = (posicionObjetivo - global_position).normalized()

# _physics_process se ejecuta cada frame
func _physics_process(delta: float) -> void:
	global_position += direccion * velocidad * delta

# Esta función detecta colisiones con el jugador y hace que el jugador muera y pierda una vida
func _on_body_entered(body: Node2D) -> void:
	if body is Jugador or Jugador2Cañones:
		var jugador = body 
		jugador.morir()
		
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	
func desaparecerNave():
	emit_signal("desaparecer", puntos)
	queue_free()
