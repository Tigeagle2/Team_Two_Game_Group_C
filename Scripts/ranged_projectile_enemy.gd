extends Area2D
var projectile_build_up_time: float
var speed: float = 300
var velocity: Vector2 = Vector2.ZERO
var can_move: bool = false
var direction
var collision_groups = ["weapon_heavy", "weapon_light", "weapon_special"]
var damage: int = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	var player = get_tree().get_first_node_in_group("player")
	if player:
		fade_in(projectile_build_up_time - (projectile_build_up_time / 8))
		await get_tree().create_timer(projectile_build_up_time, false).timeout
		direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		can_move = true
		$CollisionShape2D.set_deferred("disabled", false)
		audiomanager.attempt_to_play_projectile_sound(global_position)
	await get_tree().create_timer(1.5, false).timeout
	queue_free()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_move:
		position += velocity * delta
func setup(build_up_time: float):
	projectile_build_up_time = build_up_time
func fade_in(duration: float):
	modulate.a = 0
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_STOP)
	tween.tween_property(self, "modulate:a", 1.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished


func _on_area_entered(area: Area2D) -> void:
	if collision_groups.any(func(group): return area.is_in_group(group)):
		queue_free()



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("terrain"):
		queue_free()
