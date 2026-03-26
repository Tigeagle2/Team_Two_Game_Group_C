extends Area2D
## How long the hitbox stays active for damage
@export var attack_damage_duration: float = 0.3
## how long the attack takes before the player can attack again
@export var attack_duration: float = 0.5
var damage: int = 50
var knockback_strength: int = 500
signal attack_finished
var attack_sound = preload("res://Assets/Sound_Effects/Blunt_Hit.mp3")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.set_deferred("disabled", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func attack():
	audiomanager.play_sound_effect(attack_sound, global_position, 1.0, -15.0)
	$CollisionShape2D.set_deferred("disabled", false)
	await get_tree().create_timer(attack_damage_duration, false).timeout
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(attack_duration - attack_damage_duration, false).timeout
	attack_finished.emit()
		
		
