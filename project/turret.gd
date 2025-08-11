extends Node2D

var shoot_interval := 1.0   # seconds between shots
var bullet_scene := preload("res://bullet.tscn")
var bullet_speed := 500.0

var shoot_timer := 0.0
var muzzle = global_position

func _process(delta):
	shoot_timer -= delta
	if shoot_timer <= 0:
		shoot()
		shoot_timer = shoot_interval

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = global_position
	# Calculate direction (e.g., turret's barrel facing direction)
	var direction = (get_global_transform().x).normalized()
	bullet.linear_velocity = direction * bullet_speed
	get_parent().add_child(bullet)
