extends Node

@onready var music_player: AudioStreamPlayer = $music_player
@onready var sfx_player: AudioStreamPlayer = $sfx_player

var music_enabled: bool = true
var sfx_enabled: bool = true
var fade_time: float = 3.0

var _fade_target_volume_db: float = 0
var _fade_timer: float = 0
var _fade_direction: int = 0

func _ready():
	music_player.volume_db = -80

func _process(delta: float):
	if _fade_direction != 0:
		_fade_timer += delta
		var t = _fade_timer / fade_time
		if t > 1:
			t = 1
			_fade_direction = 0
		music_player.volume_db = lerp(music_player.volume_db, _fade_target_volume_db, t)


func play_music(track: AudioStream):
	if music_enabled and music_player.stream != track:
		music_player.stream = track
		music_player.play()
		fade_in_music()

func stop_music():
	fade_out_music()

func fade_in_music():
	_fade_target_volume_db = 0
	_fade_timer = 0
	_fade_direction = 1

func fade_out_music():
	_fade_target_volume_db = -80
	_fade_timer = 0
	_fade_direction = -1

func toggle_music(enabled: bool):
	music_enabled = enabled
	print(enabled)
	if enabled:
		if not music_player.playing and music_player.stream:
			music_player.play()
		fade_in_music()
	else:
		fade_out_music()


func play_sfx(track: AudioStream):
	if sfx_enabled:
		sfx_player.stream = track
		sfx_player.play()

func toggle_sfx(enabled: bool):
	sfx_enabled = enabled
