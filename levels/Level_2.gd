extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var num_pressed = 0
var win_condition = 4
var win_check_array = []
onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	$Popup.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if num_pressed == win_condition:
		win()
	if timer.get_time_left() == 0:
		num_pressed = 0
		turn_off_buttons()
		win_check_array = []

func press_button(body_name, button_name):
	if not [body_name, button_name] in win_check_array:
		win_check_array.push_back([body_name, button_name])
		var hit_button = get_node(button_name)
		hit_button.on.show()
		hit_button.off.hide()
		if num_pressed == 0:
			timer.start()
		num_pressed += 1

func win():
	var file = File.new()
	file.open("res://saves/0.dat", File.WRITE)
	file.store_string("3")
	file.close()
	$Popup.show()

func _on_Button_pressed():
	get_tree().change_scene("res://levels/Level_3.tscn")

func turn_off_buttons():
	for subset in win_check_array:
		var button_name = subset[1]
		var hit_button = get_node(button_name)
		hit_button.on.hide()
		hit_button.off.show()
