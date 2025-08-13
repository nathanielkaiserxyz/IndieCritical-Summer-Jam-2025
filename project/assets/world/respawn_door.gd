extends Area2D

func _on_body_entered(_body: Node2D) -> void:
	PlayerData.respawn_position = self.global_position
	PlayerData.respawn_door = 0
	await get_tree().create_timer(.25).timeout
	PlayerData.respawn_door = 1
	$respawn_door.animation = "respawn_here"
	$respawn_door.play($respawn_door.animation)

func _physics_process(_delta):
	if PlayerData.respawn_door == 0:
		$respawn_door.animation = "not_respawn_here"
		$respawn_door.play($respawn_door.animation)
		
		
