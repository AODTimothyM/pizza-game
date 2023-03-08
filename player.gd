extends CharacterBody2D

@export var skinColor = Color.WHITE
@export var shirtColor = Color.WHITE
@export var pantsColor = Color.WHITE

@export var acceleration = 500
@export var maxSpeed = 80
@export var friction = 500

enum {
	walk
}

var state = walk

@onready var animationPlayer = $AnimationPlayer
#@onready var sprite = $Sprite2D
@onready var camera = $Camera2D
#@onready var walkEffect = $Walk

signal healthChanged(health_value)
var health = 3

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority(): return
	camera.enabled = true
	velocity = Vector2.ZERO

func get_input():
	#if not is_multiplayer_authority(): return Vector2.ZERO
	
	var Input_vector = Vector2.ZERO
	Input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	Input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	Input_vector = Input_vector.normalized()
	return Input_vector

func _physics_process(delta):
	match state:
		walk:
			walkState(delta)

func walkState(delta):
	var Input_vector = get_input()
	
	if Input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(Input_vector * maxSpeed, acceleration * delta)
		animationPlayer.play("Walk")
		if Input.is_action_pressed("left"): $Sprites.scale.x = -1
		elif Input.is_action_pressed("right"): $Sprites.scale.x = 1
		#if !walkEffect.playing: walkEffect.play()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		animationPlayer.play("Idle")
		#walkEffect.stop()
		
	move_and_slide()
