extends Node

@onready var mainMenu = $CanvasLayer/TitleMenu
@onready var addressEntry = $CanvasLayer/TitleMenu/MarginContainer/VBoxContainer/PlayButtons/AddressEntry
@onready var hud = null
@onready var minigames = $CanvasLayer/Minigames
@onready var health_bar = null

@onready var tablesMinigame = $CanvasLayer/Minigames/CleaningTablesMinigame
@onready var drivingMinigame = $CanvasLayer/Minigames/DrivingMinigame

var savePath = "user://pizza.manic"
const Player = preload("res://player.tscn") #preload("res://Player/player.tscn")
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

func _ready():
	$World.nodeSpawned.connect(_on_multiplayer_spawner_spawned)
	
	if FileAccess.file_exists(savePath):
		$CanvasLayer/TitleMenu.visible = true
		$CanvasLayer/CharacterEditor.visible = false
	else:
		$CanvasLayer/TitleMenu.visible = false
		$CanvasLayer/CharacterEditor.visible = true

func _unhandled_input(_event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _on_host_pressed():
	mainMenu.hide()
	#minigames.show()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	
	upnp_setup()

func _on_join_pressed():
	mainMenu.hide()
	#minigames.show()
	
	enet_peer.create_client(addressEntry.text, PORT)
	multiplayer.multiplayer_peer = enet_peer
	
func _on_quit_pressed():
	get_tree().quit()

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	#add_child(player)
	$World.addPlayer(player)
	
	# Connect player signals to methods here
	if player.is_multiplayer_authority():
		print("Host signal connected")
		player.touchedMinigame.connect(activateMinigame)
		player.escapedMinigame.connect(deactivateMinigame)

func remove_player(peer_id):
	$World.removePlayer(peer_id)

func _on_multiplayer_spawner_spawned(node):
	if node.is_multiplayer_authority():
		print("Client signal connected")
		node.touchedMinigame.connect(activateMinigame)
		node.escapedMinigame.connect(deactivateMinigame)

func activateMinigame(player: CharacterBody2D, minigame: String, trigger: Area2D) -> void:
	match minigame:
		"Cleaning Tables":
			tablesMinigame.newGame()
			tablesMinigame.minigameCompleted.connect(trigger.queue_free)
			tablesMinigame.show()
		"Driving":
			player.deactivate()
			drivingMinigame.newGame()
			drivingMinigame.show()
		_:
			print("No minigame found.")
			return
	minigames.show()
	
func deactivateMinigame(_player: CharacterBody2D, minigame: String, _trigger: Area2D) -> void:
	match minigame:
		"Cleaning Tables":
			tablesMinigame.hide()
		_:
			print("No minigame found.")
			return
	minigames.hide()

func upnp_setup():
	var upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)
	
	#print(upnp.get_gateway())
	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
		"UPNP Invalid Gateway!")

	var map_result = upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port Mapping Failed! Error %s" % map_result)
	
	print("Success! Join Address: %s" % upnp.query_external_address())

