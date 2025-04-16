# Script del laser disparado por las naves
extends Area2D

# Vector que indica la dirección a la que va a salir el laser.
var vectorDeMovimiento := Vector2(0, -1)

# Velocidad del laser
@export var velocidad := 500.0
@onready var disparoJugador = $SonidoLaser
@onready var spriteLaser = $Sprite2D
@onready var collisionNave = $CollisionShape2D

func _ready() -> void:
	disparoJugador.play()

func _physics_process(delta):
	# Mueve el láser en la dirección de su rotación, multiplicado por su velocidad y el tiempo entre frames.
	global_position += vectorDeMovimiento.rotated(rotation) * velocidad * delta

# Cuando el laser sale de la pantalla se elimina
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

# Si el laser toca un asteroide lo hace explotar
func _on_area_entered(area: Area2D) -> void:
	borrar_disparo()
	
	if area is naveEnemiga:
		var nave = area
		nave.desaparecerNave()
		queue_free()

	elif area is asteroideDosDeVida:
		var asteroid_dos_vidas = area
		asteroid_dos_vidas.asteroideGolpeado()
		$SonidoGolpearAsteroide.play()
		await $SonidoGolpearAsteroide.finished
		queue_free()

	elif area is asteroide:
		var asteroid = area
		asteroid.explosion()
		$SonidoGolpearAsteroide.play()
		await $SonidoGolpearAsteroide.finished
		queue_free()

func borrar_disparo():
	spriteLaser.visible = false
	collisionNave.set_deferred("disabled", true)
	
