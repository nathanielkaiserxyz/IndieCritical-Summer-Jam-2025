extends Node2D

var shoot_interval := 1.0   # seconds between shots
var bullet_scene := preload("res://bullet.tscn")
var bullet_speed := 100.0

var shoot_timer := 0.0
@onready var muzzle = $firing_position

func _process(delta):
	shoot_timer -= delta
	if shoot_timer <= 0:
		shoot()
		shoot_timer = shoot_interval

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.get_child(1).modulate = LevelLoader.get_level_color()
	bullet.position = muzzle.global_position
	var direction = (muzzle.global_position - global_position).normalized()
	bullet.linear_velocity = direction * bullet_speed
	get_parent().add_child(bullet)
