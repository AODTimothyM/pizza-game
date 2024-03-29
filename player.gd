extends CharacterBody2D

@export var acceleration = 500
@export var maxSpeed = 80
@export var friction = 500

enum {
	walk,
	idle
}

var state = walk

@onready var animationPlayer = $AnimationPlayer
@onready var camera = $Camera2D
@onready var body = $Sprites/Body
@onready var shirt = $Sprites/Shirt
@onready var pants = $Sprites/Pants
@onready var hair = $Sprites/Hair
#@onready var walkEffect = $Walk

signal touchedMinigame(player: CharacterBody2D, minigame: String, trigger: Area2D)
signal escapedMinigame(player: CharacterBody2D, minigame: String, trigger: Area2D)

var savePath = "user://pizza.manic"

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority(): return
	camera.enabled = true
	velocity = Vector2.ZERO
	
	if FileAccess.file_exists(savePath):
		print("file found")
		var file = FileAccess.open(savePath, FileAccess.READ)
		var save = file.get_var()
		
		# Body
		body.frame_coords.y = save.body
		# Hair
		hair.frame = save.hairType
		hair.modulate = save.hairColor
		# Shirt
		shirt.modulate = save.shirt
		# Pants
		pants.modulate = save.pants
	else:
		print("file not found")

func get_input():
	if not is_multiplayer_authority(): return Vector2.ZERO
	
	var Input_vector = Vector2.ZERO
	Input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	Input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	Input_vector = Input_vector.normalized()
	return Input_vector

func _physics_process(delta):
	match state:
		walk:
			walkState(delta)
		idle:
			pass

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
	
func enteredTrigger(minigame: String, trigger: Area2D) -> void:
	emit_signal("touchedMinigame", self, minigame, trigger)
	
func exitedTrigger(minigame: String, trigger: Area2D) -> void:
	emit_signal("escapedMinigame", self, minigame, trigger)
	
func activate() -> void:
	state = walk
	
func deactivate() -> void:
	state = idle
