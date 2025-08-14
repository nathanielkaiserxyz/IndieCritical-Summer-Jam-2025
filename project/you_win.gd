extends Node2D


@onready var total_time_text = $total_time
@onready var level_one_time = $level1/level_one_time
@onready var level_two_time = $level2/level_two_time
@onready var level_three_time = $level3/level_three_time

@onready var flames_gathered = $flames_gathered
@onready var flame_one = $flame1
@onready var flame_two = $flame2
@onready var flame_three = $flame3

@onready var star_scene = preload("res://shooting_star.tscn")
@onready var player = get_node("Player/player")

func _ready():
	#set deaths
	$deaths.text = str(PlayerData.player_death_count)
	
	#set times
	level_one_time.text   = "1: %02d:%02d" % [int(LevelLoader.level_times[1] / 60), int(LevelLoader.level_times[1]) % 60]
	level_two_time.text   = "2: %02d:%02d" % [int(LevelLoader.level_times[2] / 60), int(LevelLoader.level_times[2]) % 60]
	level_three_time.text = "3: %02d:%02d" % [int(LevelLoader.level_times[3] / 60), int(LevelLoader.level_times[3]) % 60]

	var total_time = LevelLoader.level_times[1] + LevelLoader.level_times[2] + LevelLoader.level_times[3]
	total_time_text.text = "%02d:%02d" % [int(total_time / 60), int(total_time) % 60]
	
	#set flames
	var count = 0
	if LevelLoader.flames[0]:
		count += 1
		flame_one.show()
	if LevelLoader.flames[1]:
		count += 1
		flame_two.show()
	if LevelLoader.flames[2]:
		count += 1
		flame_three.show()
	
	flames_gathered.text = str(count) + "/3"
	
	#set STARS
	if LevelLoader.level_times[1] < 300:
		$level1/star1.show()
	if LevelLoader.level_times[1] < 30:
		$level1/star2.show()
	if LevelLoader.level_times[1] < 21 and LevelLoader.flames[0]:
		$level1/star3.show()
	
	if LevelLoader.level_times[2] < 200:
		$level2/star1.show()
	if LevelLoader.level_times[2] < 180:
		$level2/star2.show()
	if LevelLoader.level_times[2] < 119 and LevelLoader.flames[1]:
		$level2/star3.show()
	
	if LevelLoader.level_times[3] < 200:
		$level3/star1.show()
	if LevelLoader.level_times[3] < 120:
		$level3/star2.show()
	if LevelLoader.level_times[3] < 56 and LevelLoader.flames[2]:
		$level3/star3.show()


func _on_timer_timeout():
	var star = star_scene.instantiate()
	add_child(star)
	star.start_star(player.global_position)
	
