extends RigidBody2D

var v = global_position

func _ready():
	$key.play("default")
	$key_outline.play("default")
	v = global_position
	var player = get_node("../../Player/player")
	player.connect("key_reset", Callable(self, "_on_respawn"))

func _on_respawn():
	var player = get_node("../../Player/player")
	player.disconnect("key_reset", Callable(self, "_on_respawn"))
	queue_free()                
	var new_key_scene = preload("res://key.tscn") 
	var new_key = new_key_scene.instantiate()
	new_key.global_position = v
	get_parent().get_parent().add_child(new_key)  
	
	
