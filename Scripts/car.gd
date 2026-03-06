extends Area2D

var direction: String
var speed: int = 500
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match direction:
		"NORTH":
			position.y -= delta * speed
		"SOUTH":
			position.y += delta * speed
		"EAST":
			position.x += delta * speed
		"WEST":
			position.x -= delta * speed
func _car_setup(direction_in: String):
	direction = direction_in
