extends Node

# Ordered list of your level scene paths
var levels = [
	"res://level_one.tscn",
	"res://level_two.tscn",
	"res://level_three.tscn"
]
var flames = [
	false,
	false,
	false
]

var level_color = [
	Color(1.0, 1.0, 1.0),
	Color(0.0, 1.0, 1.0),
	Color(0.0, 1.0, 0.0),
]
var level_times = [
	0,
	0,
	0,
	0
]

var end_scene = false
var current_level_index := 0
var current_level_time_index := 0

func _physics_process(delta: float) -> void:
	level_times[current_level_time_index] += delta

func start_game():
	end_scene = false
	current_level_index = 0
	current_level_time_index = 1
	load_level(current_level_index)
	
	flames = [
		false,
		false,
		false
	]
	
	level_times = [
		0,
		0,
		0,
		0
	]
	PlayerData.player_death_count = 0
	PlayerData.skins = [Vector4(1.0,1.0,1.0,1.0),]

func load_level(index: int):
	if index >= 0 and index < levels.size():
		current_level_index = index
		current_level_time_index = index + 1
		if index == 1:
			PlayerData.append_skins(Vector4(0.0,1.0,1.0,1.0))
		if index == 2:
			PlayerData.append_skins(Vector4(0.0,1.0,0.0,1.0))
		
		get_tree().change_scene_to_file(levels[index])
	else:
		end_scene = true
		get_tree().change_scene_to_file("res://you_win.tscn")

func next_level():
	current_level_time_index + 1
	load_level(current_level_index + 1)
	
func get_level_color():
	if end_scene:
		return level_color[0]
	return level_color[current_level_index]

func set_flame_found():
	flames[current_level_index] = true
	print(flames[current_level_index])


	
