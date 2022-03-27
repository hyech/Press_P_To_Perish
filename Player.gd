extends KinematicBody2D

var origin_pos = Vector2(72, 584)
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var velocity = Vector2()
var max_speed = 400
var x_accel = 100
var clone_num = 0
var max_clones = 19
var file
var dir = Directory.new()
var active = true
var can_press = false
var overlap_button_name = ""
onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	position = origin_pos
	timer.start()
	file = File.new()
	var filename = "res://tmp/clone" + String(clone_num) + ".dat"
	file.open(filename, File.WRITE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var key_press_array = []
	
	if timer.get_time_left() == 0:
		active = true
		
	if active:
		if abs(velocity.x) < max_speed:
			if Input.is_action_pressed("move_right"):
				velocity.x += x_accel
				key_press_array.push_back("move_right")
			if Input.is_action_pressed("move_left"):
				velocity.x -= x_accel
				key_press_array.push_back("move_left")
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y = -800
			key_press_array.push_back("jump")
		if Input.is_action_just_pressed("perish"):
			perish()
		if Input.is_action_just_pressed("remove_clone"):
			remove_clone()
		if can_press and Input.is_action_just_pressed("button_click"):
			get_parent().press_button(self.name, overlap_button_name)
			key_press_array.push_back("button_click")

		if clone_num < max_clones:
			file.store_string(var2str(key_press_array) + "\n")

		if velocity.x < 50 and velocity.x > -50:
			velocity.x = 0
		elif velocity.x > 0:
			velocity.x -= 50
		elif velocity.x < 0:
			velocity.x += 50
		
		
func _physics_process(delta):
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)


func perish():
	if clone_num < max_clones:
		
		active = false
		timer.start()
		
		velocity = Vector2(0, 0)
		position = origin_pos
		
		get_parent().turn_off_buttons()
		
		file.close()
		
		# Add the clone as a scene
		var clone = preload("res://Clone.tscn").instance()
		clone.set_name("Clone" + String(clone_num))
		clone.id = clone_num
		clone.position = origin_pos
		get_parent().add_child(clone)
		
		for i in range(clone_num):
			var clone_to_reset = get_parent().get_node("Clone" + String(i))
			clone_to_reset.clone_reset()
		
		clone_num += 1
		
		if clone_num < max_clones:
			file.open("res://tmp/clone" + String(clone_num) + ".dat", File.WRITE)
	
func remove_clone():
	if clone_num > 0:
		active = false
		timer.start()
		
		velocity = Vector2(0, 0)
		position = origin_pos
		
		get_parent().turn_off_buttons()
		
		file.close()
		
		dir.remove("res://tmp/clone" + String(clone_num) + ".dat")
		
		clone_num -= 1
		
		for i in range(clone_num):
			var clone = get_parent().get_node("Clone" + String(i))
			clone.clone_reset()
		
		var clone_to_kill = get_parent().get_node("Clone" + String(clone_num))
		clone_to_kill.kill()
		get_parent().remove_child(clone_to_kill)
		dir.remove("res://tmp/clone" + String(clone_num) + ".dat")
		
		file.open("res://tmp/clone" + String(clone_num) + ".dat", File.WRITE)
	
	else:
		velocity = Vector2(0, 0)
		position = origin_pos
		
		get_parent().turn_off_buttons()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		clean()
		get_tree().quit()
		
func _exit_tree():
	clean()

func clean():
	active = false
	file.close()
	for i in range(clone_num):
		dir.remove("res://tmp/clone" + String(i) + ".dat")
	dir.remove("res://tmp/clone" + String(clone_num) + ".dat")
