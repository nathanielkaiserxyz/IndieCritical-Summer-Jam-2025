extends Node

var skin_index = 0
var temp = 0

var skins = [
	"Color(1, 1, 1, 1)",
	"Color(0, 1, 1, 1)",
	"Color(1, 1, 0, 1)",
]

func new_skin():
	if skin_index + 1 == skins.size():
		temp = skin_index
		skin_index = 0
		return skins[temp]
	skin_index += 1
	return skins[skin_index]
