extends Control

@onready var mainButtons = $MarginContainer/VBoxContainer/MainButtons
@onready var playButtons = $MarginContainer/VBoxContainer/PlayButtons
@onready var optionMenu = $MarginContainer/VBoxContainer/OptionsMenu
@onready var volumeSlider = $MarginContainer/VBoxContainer/OptionsMenu/Volume/VolumeSlider

@onready var characterEditor = get_parent().get_node("CharacterEditor")

# Called when the node enters the scene tree for the first time.
func _ready():
	mainButtons.get_node("Play").grab_focus()
	print(AudioServer.get_bus_volume_db(0))
	volumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(0))

func _on_play_pressed():
	mainButtons.visible = false
	playButtons.visible = true
	playButtons.get_node("Host").grab_focus()

func _on_back_pressed():
	playButtons.visible = false
	optionMenu.visible = false
	mainButtons.visible = true
	mainButtons.get_node("Play").grab_focus()

func _on_options_pressed():
	mainButtons.visible = false
	optionMenu.visible = true
	optionMenu.get_node("Fullscreen").grab_focus()

func _on_fullscreen_toggled(button_pressed):
	var mode = 3 if button_pressed else 0
	DisplayServer.window_set_mode(mode)

func _on_volume_checkbox_toggled(button_pressed):
	print(button_pressed)
	if button_pressed:
		var volume = volumeSlider.value
		AudioServer.set_bus_volume_db(0, linear_to_db(volume))
	else:
		AudioServer.set_bus_volume_db(0, linear_to_db(0))

func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func _on_edit_character_pressed():
	visible = false
	characterEditor.visible = true
