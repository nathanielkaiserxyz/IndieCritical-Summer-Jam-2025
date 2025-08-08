extends CharacterBody2D

const SPEED = 200.0

const JUMP_VELOCITY = -300.0

const WALL_JUMP_POWER = 75
const WALL_SLIDE_GRAVITY = 50
var is_wall_sliding = false

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
	
	update_animation()
	
	var was_on_floor = is_on_floor()
	
	move_and_slide()
	jump()
	wallslide(delta)
	
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
		
func jump():
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor() or !coyote_timer.is_stopped():
			velocity.y = JUMP_VELOCITY
			$jump.play()
		if is_on_wall() and Input.is_action_pressed('ui_right'):
			velocity.y = JUMP_VELOCITY
			velocity.x = -WALL_JUMP_POWER
			wall_jump_timer.start()
			$jump.play()
		if is_on_wall() and Input.is_action_pressed('ui_left'):
			velocity.y = JUMP_VELOCITY
			velocity.x = WALL_JUMP_POWER
			wall_jump_timer.start()
			$jump.play()
			
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
	

func update_animation():
	if !is_on_floor():
		$AnimatedSprite2D.animation = "jump"
	elif velocity.x > 0.1 and is_ducking:
		$AnimatedSprite2D.animation = "duck_walk"
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < -0.1 and is_ducking:
		$AnimatedSprite2D.animation = "duck_walk"
		$AnimatedSprite2D.flip_h = true
	elif is_ducking:
		$AnimatedSprite2D.animation = "duck"
	elif velocity.x > 0.1:
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < -0.1:
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.animation = "idle"
	
	$AnimatedSprite2D.play($AnimatedSprite2D.animation)
	
