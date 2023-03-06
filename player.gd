extends CharacterBody2D

@export var speed = 200
@export var friction = 1
@export var acceleration = 0.1

@onready var camera = $Camera2D


signal healthChanged(health_value)
var health = 3

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority(): return
	camera.enabled = true

func get_input():
	if not is_multiplayer_authority(): return
	
	var input = Vector2()
	if Input.is_action_pressed('ui_right'):
		input.x += 1
	if Input.is_action_pressed('ui_left'):
		input.x -= 1
	if Input.is_action_pressed('ui_down'):
		input.y += 1
	if Input.is_action_pressed('ui_up'):
		input.y -= 1
	return input

func _physics_process(delta):
	var direction = get_input()
	if direction:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()
	
@rpc("any_peer")
func receive_damage():
	health -= 1
	if health <= 0:
		health = 3
		position = Vector2.ZERO
	healthChanged.emit(health)
