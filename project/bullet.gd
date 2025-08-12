extends RigidBody2D

func _ready():
	await get_tree().create_timer(20.0).timeout
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("walls"):
		queue_free()
