extends Node

var show_player_animations := true
var skin_index = 0
var temp = 0

var has_key = false
var respawn_position : Vector2
var respawn_door = 0
var player_death_count = 0

var skins = [
	Vector4(1.0,1.0,1.0,1.0),
]
#Vector4(0.0,1.0,1.0,1.0)
#Vector4(0.0,1.0,0.0,1.0)

func append_skins(new_color : Vector4):
	skins.append(new_color)

func new_skin():
	if skin_index + 1 == skins.size():
		temp = skin_index
		skin_index = 0
		return skins[temp]
		
	skin_index += 1
	return skins[skin_index - 1]

func add_death():
	player_death_count += 1

func force_skin_change():
	skin_index = skins.size() - 1
	return skins[skin_index]
	
func update_flame_color():
	return skins[skin_index]
