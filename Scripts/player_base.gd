extends CharacterBody2D
class_name PlayerBase

@onready var heavy_weapon = $weapons/heavy_weapon
@onready var light_weapon = $weapons/light_weapon
@onready var special_weapon = $weapons/special_weapon
var can_attack: bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _input(event: InputEvent) -> void:
	if can_attack:
		if event.is_action_pressed("heavy_attack"):
			can_attack = false
			heavy_weapon.attack()
			await heavy_weapon.attack_finished
			can_attack = true
		if event.is_action_pressed("light_attack"):
			can_attack = false
			light_weapon.attack()
			await light_weapon.attack_finished
			can_attack = true
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if "setup_active" in body:
			if !body.setup_active:
				gamemanager.attempt_to_take_damage(body.damage)
func _on_hitbox_area_entered(area: Node2D) -> void:
	if area.is_in_group("enemy"):
		if "damage" in area:
			gamemanager.attempt_to_take_damage(area.damage)
