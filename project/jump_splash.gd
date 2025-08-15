extends AnimatedSprite2D

func _ready():
	animation = "default"
	play()

func _on_animation_finished() -> void:
	queue_free()
