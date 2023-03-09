extends Node2D

var rng = RandomNumberGenerator.new()
@onready var markers = $Table/Markers.get_children()
const Mess = preload("res://Minigames/mess.tscn")

func _ready():
	rng.randomize()
	var messAmount = randi_range(1, 7)
	for i in range(messAmount):
		var mess = Mess.instantiate()
		var marker = markers[randi() % markers.size()]
		add_child(mess)
		mess.global_position = marker.global_position
		marker.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
