extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$pause_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		_toggle_pause()

func _toggle_pause():
	var is_paused = !get_tree().paused
	get_tree().paused = is_paused
	$pause_menu.visible = is_paused
	if is_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$pause_menu/resume_button.grab_focus()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_resume_button_pressed() -> void:
	_toggle_pause()
