extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

@onready var coyote_timer = $CoyoteTimer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_ducking = false

func _physics_process(delta):
	is_ducking = Input.is_action_pressed("ui_down")
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_up") and (is_on_floor() or !coyote_timer.is_stopped()):
		velocity.y = JUMP_VELOCITY
		update_animation()

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
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
		
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
	
