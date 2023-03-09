extends Control

@onready var body = $Sprites/Body
@onready var shirt = $Sprites/Shirt
@onready var pants = $Sprites/Pants
@onready var hair = $Sprites/Hair

@onready var shirtColorPicker = $ColorPickers/ShirtColor
@onready var pantsColorPicker = $ColorPickers/PantsColor
@onready var hairColorPicker = $ColorPickers/HairColor

var savePath = "user://pizza.manic"
@onready var titleMenu = get_parent().get_node("TitleMenu")

var colors = [Color(1.0, 0.0, 0.0, 1.0),
		Color(0.0, 1.0, 0.0, 1.0),
		Color(0.0, 0.0, 1.0, 1.0)]

func _ready():
	if FileAccess.file_exists(savePath):
		print("file found")
		var file = FileAccess.open(savePath, FileAccess.READ)
		var save = file.get_var()
		
		# Body
		body.frame_coords.y = save.body
		# Hair
		hair.frame = save.hairType
		hair.modulate = save.hairColor
		hairColorPicker.color = save.hairColor
		# Shirt
		shirt.modulate = save.shirt
		shirtColorPicker.color = save.shirt
		# Pants
		pants.modulate = save.pants
		pantsColorPicker.color = save.pants
	else:
		print("file not found")

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

func _on_random_pressed():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	# Body
	body.frame_coords.y = randi_range(0, 7)
	# Hair
	hair.frame = randi_range(0, 9)
	var hairColor = Color(randf(), randf(), randf(), 1.0) #colors[randi() % colors.size()]
	hair.modulate = hairColor
	hairColorPicker.color = hairColor
	# Shirt
	var shirtColor = Color(randf(), randf(), randf(), 1.0)
	shirt.modulate = shirtColor
	shirtColorPicker.color = shirtColor
	# Pants
	var pantsColor = Color(randf(), randf(), randf(), 1.0)
	pants.modulate = pantsColor
	pantsColorPicker.color = pantsColor
	
func _on_done_pressed():
	var save = {
		"body": body.frame_coords.y,
		"shirt": shirtColorPicker.color,
		"pants": pantsColorPicker.color,
		"hairType": hair.frame,
		"hairColor": hairColorPicker.color
	}
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(save)
	visible = false
	titleMenu.visible = true
