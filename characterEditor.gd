extends Control

@onready var body = $Sprites/Body
@onready var shirt = $Sprites/Shirt
@onready var pants = $Sprites/Pants
@onready var hair = $Sprites/Hair

func _on_color_picker_color_changed(color):
	pants.modulate = color

func _on_shirt_color_color_changed(color):
	shirt.modulate = color

func _on_pants_color_color_changed(color):
	pants.modulate = color
	
func _on_hair_color_color_changed(color):
	hair.modulate = color

func _on_skin_next_pressed():
	if body.frame_coords.y == body.vframes-1:
		body.frame_coords.y = 0
	else:
		body.frame_coords.y += 1

func _on_skin_back_pressed():
	if body.frame_coords.y == 0:
		body.frame_coords.y = body.vframes-1
	else:
		body.frame_coords.y -= 1


func _on_hair_next_pressed():
	if hair.frame == hair.hframes-1:
		hair.frame = 0
	else:
		hair.frame += 1


func _on_hair_back_pressed():
	if hair.frame == 0:
		hair.frame = hair.hframes-1
	else:
		hair.frame -= 1
