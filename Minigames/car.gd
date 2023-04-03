extends CharacterBody2D

@export var acceleration = 5000
@export var maxSpeed = 800
@export var friction = 500

func get_input():
	if not is_multiplayer_authority(): return Vector2.ZERO
	
	var Input_vector = Vector2.ZERO
	#Input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	Input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	Input_vector = Input_vector.normalized()
	return Input_vector

func _physics_process(delta):
	var Input_vector = get_input()
	
	if Input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(Input_vector * maxSpeed, acceleration * delta)
		#if !walkEffect.playing: walkEffect.play()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		#walkEffect.stop()
		
	move_and_slide()
