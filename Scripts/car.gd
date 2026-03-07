extends Area2D

var direction: String
const speed: int = 500
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
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
			$Sprite2D.rotate(deg_to_rad(-90))
		"SOUTH":
			$Sprite2D.rotate(deg_to_rad(90))
		"EAST":
			pass
		"WEST":
			$Sprite2D.flip_h = 1
		
