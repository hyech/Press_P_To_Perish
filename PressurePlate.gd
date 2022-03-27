extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Area2D_body_entered(body):
	pressed = true
	$PushyThing.hide()

func _on_Area2D_body_exited(body):
	pressed = false
	$PushyThing.show()
