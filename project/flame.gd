extends Area2D

@onready var flame = $flame

func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		LevelLoader.set_flame_found()
		flame.get_parent().remove_child(flame)
		body.add_child(flame)
		
		var v = PlayerData.update_flame_color()
		flame.modulate = Color(v.x, v.y, v.z)
