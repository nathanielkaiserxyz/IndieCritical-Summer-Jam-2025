extends ParallaxBackground

@export var max_offset := Vector2(50, 30)

func _process(_delta):
	var viewport_size = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()

	# Convert mouse position to range (-1, 1)
	var normalized = (mouse_pos / viewport_size) * 2.0 - Vector2(1, 1)

	# Apply a parallax offset based on mouse movement
	scroll_offset = normalized * max_offset


func _on_intro_finished() -> void:
	pass # Replace with function body.
