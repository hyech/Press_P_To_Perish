extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var origin_pos = Vector2(72, 584)
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var id
var file
var velocity = Vector2()
var active = false
var max_speed = 400
var x_accel = 100
onready var timer = $Timer
var can_press = false
var overlap_button_name = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	position = origin_pos
	timer.start()
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)
	set_collision_layer_bit(id + 1, true)
	set_collision_mask_bit(id + 1, true)
	file = File.new()
	file.open("res://tmp/clone" + String(id) + ".dat", File.READ)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer.time_left == 0:
		active = true
	
	if active and file.is_open():
		var key_press_array = str2var(file.get_line())
		
		if abs(velocity.x) < max_speed:
			if "move_right" in key_press_array: 
				velocity.x += x_accel
			if "move_left" in key_press_array:
				velocity.x -= x_accel
		if "jump" in key_press_array and is_on_floor():
			velocity.y = -800
		if can_press and "button_click" in key_press_array:
			get_parent().press_button(self.name, overlap_button_name)
		if file.eof_reached():
			file.close()
			velocity = Vector2()
		
		if velocity.x < 50 and velocity.x > -50:
			velocity.x = 0
		elif velocity.x > 0:
			velocity.x -= 50
		elif velocity.x < 0:
			velocity.x += 50

func _physics_process(delta):
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)

func clone_reset():
	active = false
	file.close()
	timer.start()
	
	velocity = Vector2(0, 0)
	position = origin_pos
	
	file.open("res://tmp/clone" + String(id) + ".dat", File.READ)
	file.seek(0)

func kill():
	active = false
	file.close()
