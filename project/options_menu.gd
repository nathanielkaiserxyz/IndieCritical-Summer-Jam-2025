extends Control

var music: AudioStream = load("res://assets/sounds/mainmenu.wav")

func _ready():
	AudioManager.play_music(music)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_music_toggled(toggled_on: bool) -> void:

	AudioManager.toggle_music(false)

func _on_sound_toggled(toggled_on: bool) -> void:
	AudioManager.toggle_sfx(false)
