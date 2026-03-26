extends Area2D
var can_attack: bool = true
signal special_weapon_activated
signal attack_finished
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func attack():
	special_weapon_activated.emit()
	await get_tree().create_timer(0.5).timeout
	attack_finished.emit()
