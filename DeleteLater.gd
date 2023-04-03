extends Sprite2D


var colors = [Color(1.0, 0.0, 0.0, 1.0),
			Color(0.0, 1.0, 0.0, 1.0),
			Color(0.0, 0.0, 1.0, 1.0)]

func _ready():
	randomize()
	modulate = colors[randi() % colors.size()]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	modulate = colors[randi() % colors.size()]
