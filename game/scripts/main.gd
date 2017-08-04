extends Node2D
var max_x = 100
var max_y = 30
var min_x = 5
var min_y = 5
var global
var go = false
var touch = false
var first_box
var touch_pos = Vector2(0,0)
var drag_pos = Vector2(0,0)
var collision_counter = 0
var boxObj = load("res://objects/box.tscn")
#var first_box_size = Vector2(350,40)
var n = 0
var current_box_size = Vector2(200,20)
var next_box_size = Vector2(0,0)
#	Physics2DServer.areasetparam(getworld2d().getspace(), Physics2DServer.AREAPARAMGRAVITYVECTOR, Vector2(0,0))

func _ready():
	randomize()
	global = get_node("/root/global")
	set_fixed_process(true)
	set_process_input(true)
	var acc = Input.get_accelerometer()

	next_box_size = Vector2(randf() * (max_x - min_x) + min_x, randf() * (max_y - min_y) + min_y)
	update_UI()
	
func _fixed_process(delta):
	get_node("Position").set_pos(get_global_mouse_pos())
	var acc = Input.get_accelerometer().normalized()
	var ax = atan2(sqrt(pow(acc.y,2) + pow(acc.z,2)),acc.x) 
	var ay = atan2(sqrt(pow(acc.z,2) + pow(acc.x,2)),acc.y) 
	var az = atan2(sqrt(pow(acc.x,2) + pow(acc.y,2)),acc.z)
	
	get_node("Camera2D/Control/acc").set_text(str(ax * (180.0/PI)) + " " + str(ay * (180.0/PI)) + " " +  str(az * (180.0/PI)))
	if 	acc.x == 0.0 and acc.y == 0.0:
		get_node("Camera2D/Control/angle").hide()
	else:
		Physics2DServer.area_set_param(get_world_2d().get_space(),Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2(-acc.x,-acc.y).normalized())
		get_node("Camera2D/Control/angle").set_rot(ax)

func update_UI():
	get_node("Position/pos").set_scale(Vector2(current_box_size.x/2, current_box_size.y/2))
	get_node("Position/pos2").set_scale(Vector2(next_box_size.x/2, next_box_size.y/2))
	if n > global.highest_score:
		global.change_highest_score(n)
	get_node("Camera2D/Control/score").set_text(str(n))
	get_node("Camera2D/Control/h_score").set_text(str(global.highest_score))
	
func add_rand_box():
	var x = current_box_size.x
	var y = current_box_size.y

	var box = boxObj.instance()
	box.set_pos(get_global_mouse_pos())
	box.set_box_size(x,y)
#	if n == 0:
		
	if has_node("boxes"):
		get_node("boxes").add_child(box)
		n += 1
	
	current_box_size = next_box_size
	next_box_size = Vector2(randf() * (max_x - min_x) + min_x, randf() * (max_y - min_y) + min_y)
	update_UI()
	
	
func _input(event):
	if event.type == InputEvent.SCREEN_TOUCH:
		touch = true
		if event.index == 0:
			if event.pressed:
				touch_pos = event.pos
				drag_pos = event.pos
				touch = true
			else:
				if go:
					get_tree().reload_current_scene()
				add_rand_box()

	elif event.is_action_released("LMB") and !touch:
		if go:
			get_tree().reload_current_scene()
		add_rand_box()

func _on_Area2D_body_enter( body ):
	if body.is_in_group("box") and body != first_box:
		if collision_counter == 0:
			first_box = body
		collision_counter += 1
		if collision_counter > 1:
			print("Game over")
			get_node("Camera2D/Control/go").show()
			go = true
			n = 0
			get_node("boxes").queue_free()
			
	print(body.get_name())
	
