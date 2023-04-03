extends Node2D

var rng = RandomNumberGenerator.new()
@onready var markers = $Table/Markers.get_children()
@onready var messes = $Messes
const Mess = preload("res://Minigames/mess.tscn")

signal minigameCompleted

func _ready():
	rng.randomize()
	newGame()
		
func newGame() -> void:
	clearGame()
	markers = $Table/Markers.get_children()
	var messAmount = randi_range(1, 7)
	for i in range(messAmount):
		var mess = Mess.instantiate()
		var marker = markers[randi() % markers.size()]
		messes.call_deferred("add_child", mess)
		#messes.add_child(mess)
		mess.global_position = marker.global_position
		mess.cleanedUp.connect(messCleanedUp)
		markers.erase(marker)
		
func clearGame() -> void:
	for mess in messes.get_children():
		messes.remove_child(mess)
		mess.queue_free()


func messCleanedUp() -> void:
	if messes.get_child_count() == 1:
		#await get_tree().create_timer(1.0).timeout
		hide()
		emit_signal("minigameCompleted")
