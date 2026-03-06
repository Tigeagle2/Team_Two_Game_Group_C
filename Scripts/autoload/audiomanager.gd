extends Node
@onready var music_player = $music_player
@onready var sfx_player = $sound_effects_player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func play_music(stream: AudioStream):
	if music_player.stream == stream and music_player.playing:
		return 
	music_player.stream = stream
	music_player.play()
