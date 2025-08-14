extends Node2D

@onready var star_scene = preload("res://shooting_star.tscn")
@onready var player = get_node("Player/player")

func _on_timer_timeout():
	var star = star_scene.instantiate()
	add_child(star)
	star.start_star(player.global_position)
	
