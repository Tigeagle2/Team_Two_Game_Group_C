extends Area2D
var projectile_build_up_time: float
var speed: float = 300
var velocity: Vector2 = Vector2.ZERO
var can_move: bool = false
var direction
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		fade_in(projectile_build_up_time - (projectile_build_up_time / 8))
		await get_tree().create_timer(projectile_build_up_time).timeout
		direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		can_move = true
	await get_tree().create_timer(1.5).timeout
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
	tween.tween_property(self, "modulate:a", 1.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
