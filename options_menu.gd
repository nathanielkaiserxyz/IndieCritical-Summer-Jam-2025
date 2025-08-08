extends Control


func _on_back_pressed() -> void:
	$click.play()
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_music_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.

func _on_sound_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.
