extends Area2D

@export_enum("Toppings", "Biking", "Cutting", "Driving", "Tetris",
"Cleaning Tables", "Cleaning Floor", "Take Orders") var minigame: String

func _on_body_entered(body):
	if body is CharacterBody2D:
		body.enteredTrigger(minigame)
