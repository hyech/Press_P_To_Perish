extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var scene = get_parent()
var collision_array = []
onready var off = $Red
onready var on = $Green

# Called when the node enters the scene tree for the first time.
func _ready():
	off.show()
	on.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Button_body_exited(body):
	var colliding_node = get_parent().get_node(body.name)
	colliding_node.can_press = false
	colliding_node.overlap_button_name = ""


func _on_Button_body_entered(body):
	var colliding_node = get_parent().get_node(body.name)
	colliding_node.can_press = true
	colliding_node.overlap_button_name = self.name
