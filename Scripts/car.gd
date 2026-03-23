extends Area2D

var direction: String
const speed: int = 250
var passing_sound_played: bool = false
var vertical_texture = preload("res://Assets/sprites/CarN.png")
var distant_car = preload("res://Assets/Sound_Effects/Car_Distant_Pass.mp3")
var car_close = preload("res://Assets/Sound_Effects/Car_Close.mp3")
var knockback_force: int = 1000
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(12.0, false).timeout
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
			$Sprite2D.texture = vertical_texture
			$headlights.rotate(deg_to_rad(90))
			$honk_area.rotate(deg_to_rad(90))
		"SOUTH":
			$Sprite2D.texture = vertical_texture
			$headlights.rotate(deg_to_rad(-90))
			$honk_area.rotate(deg_to_rad(-90))
			$Sprite2D.flip_v = 1
		"EAST":
			$Sprite2D.flip_h = 1
			$headlights.rotate(deg_to_rad(180))
			$honk_area.rotate(deg_to_rad(180))
		"WEST":
			pass

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if not passing_sound_played:
		passing_sound_played = true
		if direction == "EAST" || direction == "WEST":
			var screen_center_x = get_viewport_transform().affine_inverse().origin.x + (get_viewport_rect().size.x / 2)
			audiomanager.play_sound_effect(distant_car, Vector2(screen_center_x, global_position.y), 1.5)
		elif direction == "NORTH" || direction == "SOUTH":
			var screen_center_y = get_viewport_transform().affine_inverse().origin.y + (get_viewport_rect().size.y / 2)
			audiomanager.play_sound_effect(distant_car, Vector2(global_position.x, screen_center_y), 1.5)

func _on_honk_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		audiomanager.play_sound_effect(car_close, global_position, 1.0 , -10.0)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		var push_direction = (body.global_position - global_position).normalized()
		body.knockback_velocity = push_direction * knockback_force
