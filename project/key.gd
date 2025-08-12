extends RigidBody2D

var v = position

func _ready():
	$key.play("default")
	$key_outline.play("default")
	v = global_position

func reset_key():
	global_position = v
	
