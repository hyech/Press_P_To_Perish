extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().change_scene("res://levels/Tutorial.tscn")


func _on_Button2_pressed():
	var file = File.new()
	file.open("res://saves/0.dat", File.READ)
	var level_num = file.get_line()
	if level_num == "0":
		get_tree().change_scene("res://levels/Tutorial.tscn")
	else:
		get_tree().change_scene("res://levels/Level_" + level_num + ".tscn")
