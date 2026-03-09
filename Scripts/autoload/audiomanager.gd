extends Node
@export var pool_size: int = 12          
@export var same_sound_limit: int = 3   
@export var min_interval: float = 0.05  

@onready var music_player = $music_player

var sfx_pool: Array[AudioStreamPlayer] = []
var next_player_index: int = 0
var sound_history: Dictionary = {} 

func _ready() -> void:
	for i in range(pool_size):
		var p = AudioStreamPlayer.new()
		p.bus = "Sound Effects" 
		add_child(p)
		sfx_pool.append(p)
func play_music(stream: AudioStream):
	if music_player.stream == stream and music_player.playing:
		return 
	music_player.stream = stream
	music_player.play()
func play_sound_effect(stream: AudioStream, pitch: float = 1.0, additonal_volume: float = 0):
	if not stream: return

	var now = Time.get_ticks_msec() / 1000.0
	var stream_path = stream.resource_path
	if sound_history.has(stream_path):
		if now - sound_history[stream_path] < min_interval:
			return
	
	var active_instances = 0
	for p in sfx_pool:
		if p.playing and p.stream and p.stream.resource_path == stream_path:
			active_instances += 1
	
	if active_instances >= same_sound_limit:
		return 
	sound_history[stream_path] = now
	
	var player = sfx_pool[next_player_index]
	player.stream = stream
	player.pitch_scale = pitch
	player.volume_db += additonal_volume
	player.play()
	next_player_index = (next_player_index + 1) % pool_size
