extends Area2D

var direction: String
const speed: int = 250
var sound_player: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(8.0).timeout
	queue_free()

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
	match direction:
		"NORTH":
			self.rotate(deg_to_rad(-90))
		"SOUTH":
			self.rotate(deg_to_rad(90))
		"EAST":
			pass
		"WEST":
			self.flip_h = 1
		
