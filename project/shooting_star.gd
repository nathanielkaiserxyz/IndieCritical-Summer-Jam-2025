extends Node2D

@onready var sprite = $Sprite2D 

func start_star(spawn_origin: Vector2):
	sprite.modulate = LevelLoader.get_level_color()
	position = spawn_origin + Vector2(randf_range(-400, 400), randf_range(-200, -50))
	
	var target = position + Vector2(randf_range(0, 400), randf_range(0, 100))  
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)  

	tween.tween_property(self, "position", target, 1)
	tween.tween_property(self, "rotation_degrees", randf_range(-15, 15), 1.5)
	tween.tween_property(sprite, "modulate:a", 0.0, 1.5)
	tween.set_parallel(false) 
	tween.tween_callback(Callable(self, "queue_free"))

func _ready():
	pass
