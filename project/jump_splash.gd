extends AnimatedSprite2D

func _ready():
	animation = "default"
	play()
	connect("animation_finished", Callable(self, "_on_animation_finished"))

func _on_animation_finished() -> void:
	queue_free()
