extends Node2D

signal nodeSpawned(node)

func addPlayer(node: Node) -> void:
	$YSort.add_child(node) 

func removePlayer(peerID: int) -> void:
	var player = $YSort.get_node_or_null(str(peerID))
	if player:
		print("PLAYER")
		player.queue_free()
		
func _on_multiplayer_spawner_spawned(node):
	emit_signal("nodeSpawned", node)
