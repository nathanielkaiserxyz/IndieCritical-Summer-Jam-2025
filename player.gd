extends CharacterBody2D

const SPEED = 200.0

const JUMP_VELOCITY = -300.0

const WALL_JUMP_POWER = 75
const WALL_SLIDE_GRAVITY = 50
var is_wall_sliding = false

@onready var player = $player_animations
@onready var outline = $outline_animations
@onready var coyote_timer = $CoyoteTimer
@onready var wall_jump_timer = $WallJumpTimer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_ducking = false

func _physics_process(delta):
	is_ducking = Input.is_action_pressed("ui_down")
	if not is_on_floor():
		velocity.y += gravity * delta
	
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
	wallslide(delta)
	jump()
	update_animation(delta)
	
	
	
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
		
func jump():
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor() or !coyote_timer.is_stopped():
			velocity.y = JUMP_VELOCITY
			
		if is_on_wall() and Input.is_action_pressed('ui_right'):
			velocity.y = JUMP_VELOCITY
			velocity.x = -WALL_JUMP_POWER
			wall_jump_timer.start()
			
		if is_on_wall() and Input.is_action_pressed('ui_left'):
			velocity.y = JUMP_VELOCITY
			velocity.x = WALL_JUMP_POWER
			wall_jump_timer.start()
			
			
func wallslide(delta):
	if !is_on_floor() and is_on_wall() and velocity.y >= 0:
		if Input.is_action_pressed('ui_right')	or Input.is_action_pressed('ui_left'):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false
	
	if is_wall_sliding:
		velocity.y = WALL_SLIDE_GRAVITY	
	

func update_animation(delta):
	if is_on_wall() and !is_on_floor() and velocity.y >= 0:
		if Input.is_action_pressed('ui_left'):
			player.animation = "wall_slide"
			player.flip_h = false
		elif Input.is_action_pressed('ui_right'):
			player.animation = "wall_slide"
			player.flip_h = true
		else:
			player.animation = "jump"
			
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
	
