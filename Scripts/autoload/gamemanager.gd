extends Node
const max_health: float = 100
var health
var invincible: bool = true
const invincibility_time: float = 1.0

var invincibility_timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health
	invincibility_timer = invincibility_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if invincible:
		invincibility_timer -= delta
		if (invincibility_timer <= 0):
			invincible = false
			invincibility_timer = invincibility_time
func attempt_to_take_damage(damage: float):
	if !invincible:
		invincible = true
		take_damage(damage)
	
func take_damage(damage: float):
	health -= damage
	print(health)
