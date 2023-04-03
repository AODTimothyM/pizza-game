extends Sprite2D

@export var shrinkingTime = 5.0
var shrinking = false
var mouseHovering = false
var rng = RandomNumberGenerator.new()
signal cleanedUp

func _ready():
	rng.randomize()
	shrinkingTime = randi_range(1, 5) #rng.randi() % 5
	
	if rng.randi_range(1, 100) == 1:
		print("Bad Stain")
		shrinkingTime = 30
	var randomSize = randf_range(.8, 1.2)
	scale = Vector2(randomSize, randomSize)

func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(1) and mouseHovering:
			shrinking = true
		else:
			shrinking = false

func _process(delta):
	if shrinking:
		scale.x -= delta/shrinkingTime
		scale.y -= delta/shrinkingTime
		if scale.x <= 0.05:
			emit_signal("cleanedUp")
			queue_free()

#func _on_area_2d_input_event(_viewport, event, shape_idx):
#	return
#	if event is InputEventMouseMotion and shape_idx == 0:
#		shrinking = true
#	elif event is InputEventMouseButton and shape_idx == 0:
#		shrinking = false


func _on_area_2d_mouse_entered():
	mouseHovering = true

func _on_area_2d_mouse_exited():
	mouseHovering = false
