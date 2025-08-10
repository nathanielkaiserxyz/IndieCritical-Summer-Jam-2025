extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print('here')
	PlayerData.respawn_position = global_position
	$respawn_door.animation = "respawn_here"
	$respawn_door.play($respawn_door.animation)
		
