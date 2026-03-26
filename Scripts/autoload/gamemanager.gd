extends Node
const max_health: float = 100
var health
var invincible: bool = true
const invincibility_time: float = 1.0
var invincibility_timer
const ambient_sound_frequency: float = 5
const health_regen_amount: float = 0.5
# Called when the node enters the scene tree for the first time.
var ambient_sound_timer
var wind_sound = preload('res://Assets/Sound_Effects/Ambient_Wind.mp3')
var car_far_sound = preload("res://Assets/Sound_Effects/Car_Far.mp3")
var special_charge: float = 0.0
var special_charge_rate: float = 1.0
var game_finished: bool = false
var game_started: bool = false
var score: int = 0
func _ready() -> void:
	health = max_health
	invincibility_timer = invincibility_time
	ambient_sound_timer = ambient_sound_frequency
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if invincible:
		invincibility_timer -= delta
		if (invincibility_timer <= 0):
			invincible = false
			invincibility_timer = invincibility_time
	if not game_finished and game_started:
		if ambient_sound_timer <= 0:
			var rand_roll = randi_range(0, 1)
			match rand_roll:
				0: 
					audiomanager.play_ambient_sound(wind_sound, 1.0, 5)
				1:
					audiomanager.play_ambient_sound(car_far_sound, 1.0, -20)
			ambient_sound_timer = ambient_sound_frequency
		else:
			ambient_sound_timer -= delta
	if health < max_health:
		health += delta * health_regen_amount
	elif health > max_health:
		health = max_health
	if game_started and special_charge < 100:
		special_charge += delta * special_charge_rate
	elif special_charge > 100:
		special_charge = 100
func attempt_to_take_damage(damage: float):
	if !invincible:
		invincible = true
		take_damage(damage)
	
func take_damage(damage: float):
	health -= damage
	print(health)
