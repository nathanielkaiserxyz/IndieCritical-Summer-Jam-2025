extends Node

# Ordered list of your level scene paths
var levels = [
	"res://level_one.tscn",
	"res://level_two.tscn",
	"res://level_three.tscn"
]

var current_level_index := 0

func start_game():
	current_level_index = 0
	load_level(current_level_index)

func load_level(index: int):
	if index >= 0 and index < levels.size():
		current_level_index = index
		get_tree().change_scene_to_file(levels[index])
		var player = get_node("/root/YourScene/Player")  # adjust path to your player node
		var mat = player.get_node("pla").material
		if(index == 1):
			if mat is ShaderMaterial:
					mat.set_shader_parameter("my_color", Color(1, 0.8, 0.6))
	else:
		print("No more levels — you win!")
		# Optional: load win screen
		get_tree().change_scene_to_file("res://WinScreen.tscn")

func next_level():
	load_level(current_level_index + 1)
