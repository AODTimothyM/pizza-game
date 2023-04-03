extends Node2D

const Obstacle = preload("res://Minigames/obstacle.tscn")
@onready var obstacles = $Obstacles
@onready var topMarker = $TopMarker
@onready var bottomMarker = $BottomMarker
@onready var markers = [topMarker, bottomMarker]
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func newGame() -> void:
	pass
	
func _process(_delta):
	pass

func _on_timer_timeout():
	var obstacle = Obstacle.instantiate()
	var target = markers[randi() % markers.size()]
	obstacle.global_position = target.global_position
	obstacles.add_child(obstacle)
