extends AnimatedSprite2D

@onready var target_sprite = $player_animations
@onready var current_sprite = $player_animations

func _process(delta):
	if target_sprite:
		current_sprite.flip_h = target_sprite.flip_h
		current_sprite.animation = target_sprite.animation
	current_sprite.play(current_sprite.animation)
		
