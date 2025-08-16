extends Control
var music: AudioStream = load("res://assets/world/cat-game-2.ogg")
var click: AudioStream = load("res://assets/main_menu/click.wav")

func _ready():
	AudioManager.play_music(music)

func _on_startgame_pressed():
	AudioManager.play_sfx(click)
	LevelLoader.start_game()

func _on_options_pressed():
	AudioManager.play_sfx(click)
	get_tree().change_scene_to_file("res://options_menu.tscn")

func _on_quit_pressed():
	AudioManager.play_sfx(click)
	get_tree().quit()
