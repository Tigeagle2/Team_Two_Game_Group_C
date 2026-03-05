extends PlayerBase

var speed = 500
var player_direction = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)

func _physics_process(delta):
	var direction = Input.get_vector("west", "east", "north", "south")
	var direction_x = Input.get_axis("west","east")
	if direction_x != 0:
		player_direction = sign(direction_x)	
		$Sprite2D.flip_h = (player_direction == -1)
	velocity = direction * speed 
	move_and_slide()
