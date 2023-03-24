extends Node2D

var selected_dough = false
var selected_sauce = false
var selected_cheese = false
var selected_pepperoni = false

var dough_visible = false
var sauce_visible = false
var cheese_visible = false
var pepperoni_visible = false

var button_down = false

var counter_area_entered = false

var mouse_position = get_local_mouse_position()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_position = get_local_mouse_position()
	$"Toppings/Topping Drag".set_position(mouse_position)
	
	
	if(selected_dough):
		$"Toppings/Topping Drag".frame = 3
		$"Toppings/Topping Drag".visible = true
		dough_selected()
	if(selected_sauce):
		$"Toppings/Topping Drag".frame = 0
		$"Toppings/Topping Drag".visible = true
		sauce_selected()
	if(selected_cheese):
		$"Toppings/Topping Drag".frame = 1
		$"Toppings/Topping Drag".visible = true
		cheese_selected()
	if(selected_pepperoni):
		$"Toppings/Topping Drag".frame = 2
		$"Toppings/Topping Drag".visible = true
		pepperoni_selected()
	
	if(dough_visible):
		$"Toppings/Dough".visible = true
	else: 
		$"Toppings/Dough".visible = false
	if(sauce_visible):
		$"Toppings/Sauce".visible = true
	else: 
		$"Toppings/Sauce".visible = false
	if(cheese_visible):
		$"Toppings/Cheese".visible = true
	else: 
		$"Toppings/Cheese".visible = false
	if(pepperoni_visible):
		$"Toppings/Pepperoni".visible = true
	else: 
		$"Toppings/Pepperoni".visible = false
		
	if(counter_area_entered):
		if(button_down):
			if($"Toppings/Topping Drag".frame == 3):
				dough_visible = true
				selected_dough = false
				$"Toppings/Topping Drag".visible = false
			if($"Toppings/Topping Drag".frame == 0):
				sauce_visible = true
				selected_sauce = false
				$"Toppings/Topping Drag".visible = false
			if($"Toppings/Topping Drag".frame == 1):
				cheese_visible = true
				selected_cheese = false
				$"Toppings/Topping Drag".visible = false
			if($"Toppings/Topping Drag".frame == 2):
				pepperoni_visible = true
				selected_pepperoni = false
				$"Toppings/Topping Drag".visible = false
			
	if(!button_down):
		$"Toppings/Topping Drag".visible = false
		selected_dough = false
		selected_sauce = false
		selected_cheese = false
		selected_pepperoni = false

func input(bool, Sprite2D):
	if Input.is_action_just_released("click"):
		bool = false
		Sprite2D.visible = false
	


func dough_selected():
	pass

func sauce_selected():
	pass

func cheese_selected():
	pass
	
func pepperoni_selected():
	pass


func _on_sauce_button_button_down():
	print("sauce")
	selected_sauce = true
	button_down = true
	

func _on_cheese_button_button_down():
	print("cheese")
	selected_cheese = true
	button_down = true


func _on_pepperoni_button_button_down():
	print("pepperoni") 
	selected_pepperoni = true
	button_down = true


func _on_dough_button_button_down():
	print("dough")
	selected_dough = true
	button_down = true


func _on_sauce_button_button_up():
	button_down = false

func _on_cheese_button_button_up():
	button_down = false

func _on_pepperoni_button_button_up():
	button_down = false

func _on_dough_button_button_up():
	button_down = false


func _on_counter_area_area_entered(area):
	print("Counter Area Entered")
	counter_area_entered = true
	

func _on_counter_area_area_exited(area):
	print("Counter Area Exited")
	counter_area_entered = false


func _on_clear_button_pressed():
	dough_visible = false
	sauce_visible = false
	cheese_visible = false
	pepperoni_visible = false
