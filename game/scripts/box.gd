extends RigidBody2D

func _ready():
	randomize()
	get_node("sprite").set_modulate(Color(1.0 - randf() * 0.5,1.0 - randf() * 0.5,1.0 - randf() * 0.5))
	pass

func set_box_size(x,y):
	var shape = RectangleShape2D.new()
	get_node("collision").set_shape(shape)
	get_node("collision").get_shape().set_extents(Vector2(x/2,y/2))
	get_node("sprite").set_scale(Vector2(x/2,y/2))
