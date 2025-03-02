class_name Jugador extends CharacterBody2D

signal disparoLaser(laser)
signal muerto

@export var aceleracion := 10 #Aceleracion de la nave
@export var velocidadMaximaDeLaNave := GLOBAL.get_velocidad_maxima()
@export var velocidadDeRotacion := GLOBAL.get_velocidad_rotacion()
@export var tiempoEntreDisparos := GLOBAL.get_tiempo_entre_disparos()
@onready var bocaDeCañon = $"BocaDeCañon"
@onready var sprite = $Sprite2D
@onready var estelaNave = $EstelaNave
@onready var zonaColision = $CollisionShape2D
@onready var sonidoAceleracion = $SonidoMovimiento

var vivo := true
var escenaLaser = preload("res://scennes/laser.tscn")
var enfriamientoDeDisparo = false

func _process(delta):
	
	if !vivo: return 
	if Input.is_action_pressed("shoot"):
		if !enfriamientoDeDisparo:
			enfriamientoDeDisparo = true
			dispararLaser()
			await get_tree().create_timer(tiempoEntreDisparos).timeout
			enfriamientoDeDisparo = false

func _physics_process(delta):
	if !vivo: return 
	
	var input_vector := Vector2(0, Input.get_axis("move_up", "move_down")) #Comprobar si se esta pulsando la W o la S
	
	#Cuando se pulsa w sale una estela
	if Input.is_action_pressed("move_up"):
		estelaNave.visible = true
		estelaNave.play("estela")
		
		if !sonidoAceleracion.is_playing():
			sonidoAceleracion.play()
		
	else:
		estelaNave.visible = false
		estelaNave.stop()
		sonidoAceleracion.stop()
	
	if input_vector.y == 0: #Si no se pulsa ninguna tecla
		velocity = velocity.move_toward(Vector2.ZERO, 3) #Reducimos la velocidad de 3 en 3 hasta 0
	
	velocity += input_vector.rotated(rotation) * aceleracion #Velocidad de la nave, para que parezca que no hay gravedad y que acelere hacia donde se gira
	velocity = velocity.limit_length(velocidadMaximaDeLaNave) # aplico una velocidad maxima para la nave
	
	#estos dos if hacen el giro
	if Input.is_action_pressed("rotate_right"):
		rotate(deg_to_rad(velocidadDeRotacion*delta)) 
		
	if Input.is_action_pressed("rotate_left"):
		rotate(deg_to_rad(-velocidadDeRotacion*delta))		

	move_and_slide()
	
	var tamanoPantalla = get_viewport_rect().size #Obtener el tamaño de la pantalla
	
	if global_position.y < 0: #Si la posición del jugador es menor a 0 osea se sale por encima de la pantalla
		global_position.y = tamanoPantalla.y # lo colocamos en el tamaño de la pantalla que es la parte inferior
		
	elif global_position.y > tamanoPantalla.y: #Si la posición del jugador es mayor al tamaño de la pantalla
		global_position.y = 0  #lo colocamos abajo
	
	#Igual que la función de arriba pero para la derecha y la izquierda
	if global_position.x < 0: 
		global_position.x = tamanoPantalla.x 
	elif global_position.x > tamanoPantalla.x: 
		global_position.x = 0  
	
func dispararLaser():
	var l = escenaLaser.instantiate()
	l.global_position = bocaDeCañon.global_position
	l.rotation = rotation
	emit_signal("disparoLaser", l)

func morir():
	if vivo == true:
		vivo = false	
		estelaNave.visible = false
		sprite.visible = false
		zonaColision.set_deferred("disabled", true)
		emit_signal("muerto")
	
func reaparecer(posicion):
	if vivo == false:
		vivo = true
		global_position = posicion
		velocity = Vector2.ZERO
		sprite.visible = true
		zonaColision.set_deferred("disabled", false)


func _on_estela_nave_animation_finished() -> void:
	estelaNave.pause()
