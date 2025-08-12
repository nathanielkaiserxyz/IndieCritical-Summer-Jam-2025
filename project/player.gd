extends CharacterBody2D

const SPEED = 200.0

const JUMP_VELOCITY = -300
const FRICTION = 900

const WALL_JUMP_POWER = 75
const WALL_SLIDE_GRAVITY = 50
var is_wall_sliding = false

const KILL_ZONE_Y = 1100
const PUSH_FORCE = 2000

@onready var player = $player_animations
@onready var outline = $outline_animations
@onready var coyote_timer = $coyote_timer
@onready var wall_jump_timer = $wall_jump_x_velo
@onready var wall_jump_reset = $wall_jump_reset
@onready var skin_change = $skin_change_timer
@onready var jump_buffer = $jump_buffer_timer
@onready var box_grabber = $box_grabber
@onready var drop_timer = $drop_timer
var flame := find_child("flame", true, false)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_ducking = false
var change_skin = false
var has_box = false
var has_key = false

func _ready():
	$outline_animations.material.set_shader_parameter("outline_color", PlayerData.force_skin_change())
	
func _physics_process(delta):
	_check_for_collision()
	
	if position.y > KILL_ZONE_Y:
		respawn()
	
	if Input.is_action_pressed("ui_accept") and (has_box or has_key) and drop_timer.is_stopped():
		box_grabber.node_b = NodePath("")
		has_box = false
		has_key = false
		PlayerData.has_key = false
		drop_timer.start()
	
	if Input.is_action_pressed("ui_r") and skin_change.is_stopped():
		var v = PlayerData.new_skin()
		$outline_animations.material.set_shader_parameter("outline_color", v)
		print(flame)
		if flame:
			flame.modulate = Color(v.x, v.y, v.z)
		skin_change.start()

	is_ducking = Input.is_action_pressed("ui_down")
	
	if !is_on_floor():
		velocity.y += gravity * delta
		if Input.is_action_just_pressed("ui_up"):
			jump_buffer.start()
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		jump()
	
	if wall_jump_timer.is_stopped():
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction and is_ducking:
			velocity.x = direction * SPEED/2
		elif direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	var was_on_floor = is_on_floor()
	
	move_and_slide()
	wallslide()
	jump()
	update_animation()
	
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
		
func jump():
	if has_box:
		return
			
	if is_on_floor() and !jump_buffer.is_stopped():
			velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("ui_up"):
		if !is_on_floor():
			jump_buffer.start()
			
		if is_on_floor() or !coyote_timer.is_stopped():
			velocity.y = JUMP_VELOCITY
			
		if is_on_wall() and Input.is_action_pressed('ui_right') and wall_jump_reset.is_stopped() and !has_box:
			velocity.y = JUMP_VELOCITY
			velocity.x = -WALL_JUMP_POWER
			wall_jump_timer.start()
			wall_jump_reset.start()
			
		if is_on_wall() and Input.is_action_pressed('ui_left') and wall_jump_reset.is_stopped() and !has_box:
			velocity.y = JUMP_VELOCITY
			velocity.x = WALL_JUMP_POWER
			wall_jump_timer.start()
			wall_jump_reset.start()
			
func wallslide():
	if !is_on_floor() and is_on_wall() and velocity.y >= 0 and !has_box:
		if Input.is_action_pressed('ui_right')	or Input.is_action_pressed('ui_left'):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false
	
	if is_wall_sliding:
		velocity.y = WALL_SLIDE_GRAVITY	
	

func update_animation():
	if is_on_wall() and !is_on_floor() and velocity.y >= 0 and !has_box:
		if Input.is_action_pressed('ui_left'):
			player.animation = "wall_slide"
			player.flip_h = false
		elif Input.is_action_pressed('ui_right'):
			player.animation = "wall_slide"
			player.flip_h = true
		else:
			player.animation = "jump"
	elif has_box:
		player.animation = "push_box"
	elif !is_on_floor():
		if velocity.x > 0.1:
			player.animation = "jump"
			player.flip_h = false
		elif velocity.x < -0.1:
			player.animation = "jump"
			player.flip_h = true
	elif velocity.x > 0.1 and is_ducking:
		player.animation = "duck_walk"
		player.flip_h = false
	elif velocity.x < -0.1 and is_ducking:
		player.animation = "duck_walk"
		player.flip_h = true
	elif is_ducking:
		player.animation = "duck"
	elif velocity.x > 0.1:
		player.animation = "run"
		player.flip_h = false
	elif velocity.x < -0.1:
		player.animation = "run"
		player.flip_h = true
	else:
		player.animation = "idle"
	
	outline.flip_h = player.flip_h
	outline.play(player.animation)
	player.play(player.animation)

func _check_for_collision():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody2D and Input.is_action_pressed('ui_accept') and !has_box and drop_timer.is_stopped():
			if collider.is_in_group("box"):
				box_grabber.disable_collision = true
				box_grabber.node_b = collider.get_path()
				has_box = true
				drop_timer.start()
			if collider.is_in_group("key"):
				box_grabber.disable_collision = true
				box_grabber.node_b = collider.get_path()
				has_key = true
				PlayerData.has_key = true
				
				drop_timer.start()
				
		#if collider is RigidBody2D and has_box:
			#collider.apply_force((collider.global_position - global_position).normalized() * PUSH_FORCE)

		if collider is TileMapLayer:
			var tilemap: TileMapLayer = collider
			var tile_pos = tilemap.local_to_map(collision.get_position())
			
			var data = tilemap.get_cell_tile_data(tile_pos)
			if data != null:
				if data.get_custom_data("damage") == 1:
					respawn()
				if data.get_custom_data("shootup") > 0:
					velocity.y = -data.get_custom_data("shootup")
					
func respawn():
	PlayerData.add_death()
	box_grabber.node_b = NodePath("")
	has_box = false
	drop_timer.start()
	global_position = PlayerData.respawn_position			
