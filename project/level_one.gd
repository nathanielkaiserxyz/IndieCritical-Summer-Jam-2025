extends Node2D

@onready var star_scene = preload("res://shooting_star.tscn")
@onready var player = get_node("Player/player")
var music: AudioStream = load("res://assets/world/cat-game-2.ogg")

func _ready():
	AudioManager.play_music(music)

func _on_timer_timeout():
	var star = star_scene.instantiate()
	add_child(star)
	star.start_star(player.global_position)
	
