extends Node
var sfx_pool_size: int = 12     
var ambient_pool_size: int = 5     
var same_sfx_limit: int = 3   
var min_interval: float = 0.05  
var same_ambient_limit: int = 1
@onready var music_player = $music_player
@onready var menu_player = $menu_sound_player
var projectile_sound = preload("res://Assets/Sound_Effects/Projectile.mp3")
var sfx_pool: Array[AudioStreamPlayer2D] = []
var ambient_pool: Array[AudioStreamPlayer] = []
var next_sfx_index: int = 0
var next_ambient_index: int = 0
var sfx_sound_history: Dictionary = {} 
var ambient_sound_history: Dictionary = {}
var can_play_projectile_sound: bool = true
func _ready() -> void:
	for i in range(sfx_pool_size):
		var p = AudioStreamPlayer2D.new()
		p.bus = "Sound Effects" 
		p.process_mode = Node.PROCESS_MODE_PAUSABLE
		p.max_distance = 1000
		add_child(p)
		sfx_pool.append(p)
	for i in range(ambient_pool_size):
		var p = AudioStreamPlayer.new()
		p.bus = "Ambient Sounds"
		p.process_mode = Node.PROCESS_MODE_PAUSABLE
		add_child(p)
		ambient_pool.append(p)
func attempt_to_play_projectile_sound(position: Vector2):
	if can_play_projectile_sound:
		can_play_projectile_sound = false
		play_sound_effect(projectile_sound, position, 1.0, -5.0)
		await get_tree().create_timer(0.1).timeout
		can_play_projectile_sound = true
func play_music(stream: AudioStream):
	if music_player.stream == stream and music_player.playing:
		return 
	music_player.stream = stream
	music_player.play()
func stop_music():
	music_player.stop()
func play_menu_sound(stream: AudioStream):
	menu_player.stream = stream
	menu_player.play()
func play_sound_effect(stream: AudioStream, pos: Vector2 = Vector2.ZERO, pitch: float = 1.0, additonal_volume: float = 0):
	if not stream: return

	var now = Time.get_ticks_msec() / 1000.0
	var stream_path = stream.resource_path
	
	# 1. Check interval
	if sfx_sound_history.has(stream_path):
		if now - sfx_sound_history[stream_path] < min_interval:
			return
	
	# 2. Check instance limit
	var active_instances = 0
	for p in sfx_pool:
		if p.playing and p.stream and p.stream.resource_path == stream_path:
			active_instances += 1
	
	if active_instances >= same_sfx_limit:
		return 
	var player = null
	for p in sfx_pool:
		if not p.playing:
			player = p
			break
			
	# If all are busy, fallback to the oldest one
	if player == null:
		player = sfx_pool[next_sfx_index]
		next_sfx_index = (next_sfx_index + 1) % sfx_pool_size
	sfx_sound_history[stream_path] = now
	player.stream = stream
	player.pitch_scale = pitch
	player.volume_db = additonal_volume
	player.global_position = pos
	player.play()
func play_ambient_sound(stream: AudioStream, pitch: float = 1.0, additonal_volume: float = 0):
	if not stream: return

	var now = Time.get_ticks_msec() / 1000.0
	var stream_path = stream.resource_path
	if ambient_sound_history.has(stream_path):
		if now - ambient_sound_history[stream_path] < min_interval:
			return
	
	var active_instances = 0
	for p in ambient_pool:
		if p.playing and p.stream and p.stream.resource_path == stream_path:
			active_instances += 1
	
	if active_instances >= same_ambient_limit:
		return 
	ambient_sound_history[stream_path] = now
	
	var player = ambient_pool[next_ambient_index]
	player.stream = stream
	player.pitch_scale = pitch
	player.volume_db = 0.0 + additonal_volume
	player.play()
	next_ambient_index = (next_ambient_index + 1) % ambient_pool_size
