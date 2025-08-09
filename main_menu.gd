extends Control

func _on_startgame_pressed():
	$click.play()
	LevelLoader.load_level(0)

func _on_options_pressed():
	$click.play()
	get_tree().change_scene_to_file("res://options_menu.tscn")

func _on_quit_pressed():
	$click.play()
	get_tree().quit()

func _on_intro_finished():
	$loop.play()
	
func _on_loop_finished():
	$loop.play()


func _on_startgame_focus_entered(): 
	$hover.play() 
