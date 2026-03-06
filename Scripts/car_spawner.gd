extends Area2D
@export_enum("NORTH", "SOUTH", "EAST", "WEST") var direction: String = "NORTH"
var car_scene = preload("res://Scenes/car.tscn")
var chance: int = 250
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var randomroll = randi_range(0, chance)
	if randomroll == 50:
		var car = car_scene.instantiate()
		car._car_setup(direction)
		add_child(car)
