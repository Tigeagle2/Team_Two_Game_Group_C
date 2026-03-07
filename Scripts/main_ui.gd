extends CanvasLayer

var menu_tween: Tween
func _ready() -> void:
	$pause_menu.visible = false
	$pause_menu.pivot_offset = $pause_menu.size / 2
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		_toggle_pause()

func _toggle_pause():
	var is_paused = !get_tree().paused
	get_tree().paused = is_paused
	if menu_tween:
		menu_tween.kill() 
	menu_tween = create_tween().set_parallel(true).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	if is_paused:
		_open_pause_menu()
	else:
		_close_pause_menu()
func _open_pause_menu():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$pause_menu.show()
	$pause_menu.pivot_offset = $pause_menu.size / 2
	$pause_menu/resume_button.grab_focus()
	menu_tween.tween_property($pause_menu, "scale", Vector2.ONE, 0.2)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	menu_tween.tween_property($pause_menu, "modulate:a", 1.0, 0.2)

func _close_pause_menu():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	menu_tween.tween_property($pause_menu, "scale", Vector2.ZERO, 0.2)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	menu_tween.tween_property($pause_menu, "modulate:a", 0.0, 0.2)
	menu_tween.chain().tween_callback($pause_menu.hide)

func _on_resume_button_pressed() -> void:
	_toggle_pause()
