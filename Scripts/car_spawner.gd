extends Area2D
@export_enum("NORTH", "SOUTH", "EAST", "WEST") var direction: String = "NORTH"
var car_scene = preload("res://Scenes/car.tscn")
var chance: int = 10
var car_limit = 2
const set_car_cooldown = 5

var car_cooldown
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	car_cooldown = set_car_cooldown


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var randomroll = randi_range(0, chance)
	if randomroll == 1 && self.get_child_count() < car_limit && car_cooldown <= 0:
		car_cooldown = set_car_cooldown
		var car = car_scene.instantiate()
		car._car_setup(direction)
		add_child(car)
	elif car_cooldown > 0:
		car_cooldown -= delta
