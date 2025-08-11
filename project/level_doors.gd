extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("key") and PlayerData.has_key:
		LevelLoader.next_level()
