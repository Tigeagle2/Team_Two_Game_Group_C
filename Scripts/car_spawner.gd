extends Area2D
@export_enum("NORTH", "SOUTH", "EAST", "WEST") var direction: String = "NORTH"
var car_scene = preload("res://Scenes/car.tscn")
## Chance the car has of spawning every roll
@export_range(0, 100, 0.1, "suffix:%") var chance: float = 5.0
## max amount of cars from this spawning alive at once
@export var car_limit: int = 2
## Minumun time between car spawning
@export var set_car_cooldown:float = 5.0
## How often the random roll happens
@export var roll_frequency : float = 0.5
var car_cooldown
var roll_timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	car_cooldown = set_car_cooldown
	roll_timer = roll_frequency

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if car_cooldown <= 0:
		if roll_timer <= 0:
			var randomroll = randi_range(0, 100)
			roll_timer = roll_frequency
			if randomroll <= chance && self.get_child_count() < car_limit:
				car_cooldown = set_car_cooldown
				var car = car_scene.instantiate()
				car._car_setup(direction)
				add_child(car)
		else:
			roll_timer -= delta
			
	else:
		car_cooldown -= delta
