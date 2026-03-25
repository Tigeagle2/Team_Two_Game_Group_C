extends Node2D
var can_continue: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$countdown_label.set_text("3")
	trigger_countdown()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func trigger_countdown():
	for i in 3:
		$countdown_label.set_text(str(3 - i))
		await get_tree().create_timer(1.0).timeout
	$countdown_label.set_text("Click Space or Left Button To Continue")
	fade_loop()
	can_continue = true
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and can_continue:
		get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")
func fade_loop():
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($countdown_label, "modulate:a", 0.0, 1.0)
	tween.tween_property($countdown_label, "modulate:a", 1.0, 1.0)
