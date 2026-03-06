extends HSlider
var bus_name: String = "Music"
var bus_index: int
func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func _on_value_changed(value: float):
	# value is 0.0 to 1.0 from the slider
	var db_volume = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, db_volume)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
