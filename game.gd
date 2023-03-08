extends Node

@onready var mainMenu = $CanvasLayer/TitleMenu
@onready var addressEntry = $CanvasLayer/TitleMenu/MarginContainer/VBoxContainer/PlayButtons/AddressEntry
@onready var hud = null
@onready var health_bar = null

const Player = preload("res://player.tscn") #preload("res://Player/player.tscn")
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _on_host_pressed():
	mainMenu.hide()
	#hud.show()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	
	upnp_setup()

func _on_join_pressed():
	mainMenu.hide()
	#hud.show()
	
	enet_peer.create_client(addressEntry.text, PORT)
	#enet_peer.create_client("127.0.0.1", PORT)
	multiplayer.multiplayer_peer = enet_peer
	
func _on_quit_pressed():
	get_tree().quit()

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	$World.addPlayer(player)
	
	# Connect player signals to methods here
	#if player.is_multiplayer_authority():

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	player.queue_free()
	return
	if player:
		player.queue_free()

func _on_multiplayer_spawner_spawned(node):
	print(node.name)
#	if node.is_multiplayer_authority():
#		node.healthChanged.connect(update_health_bar)

func upnp_setup():
	var upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)
	
	#print(upnp.get_gateway())
#	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
#		"UPNP Invalid Gateway!")

	var map_result = upnp.add_port_mapping(PORT)
#	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
#		"UPNP Port Mapping Failed! Error %s" % map_result)
	
	print("Success! Join Address: %s" % upnp.query_external_address())

