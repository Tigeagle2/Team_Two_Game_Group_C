extends CanvasLayer

var menu_tween: Tween
var ui_update_rate: float = 0.5
var ui_countdown
var player: Node2D = null
func _ready() -> void:
	$pause_menu.visible = false
	$flash_screen.hide()
	player = get_tree().get_first_node_in_group("player")
	player.get_node("weapons").get_node("special_weapon").special_weapon_activated.connect(_on_special_weapon_activated)
	$pause_menu.pivot_offset = $pause_menu.size / 2
	ui_countdown = ui_update_rate
func _process(delta: float) -> void:
	ui_countdown -= delta
	if ui_countdown < 0:
		ui_countdown = ui_update_rate
		$health_bar.value = gamemanager.health
		$special_charge_bar.value = gamemanager.special_charge
		$score_label.set_text("Score: " + str(gamemanager.score))
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
	$pause_menu.show()
	$special_charge_bar.hide()
	$pause_menu.pivot_offset = $pause_menu.size / 2
	$pause_menu/resume_button.grab_focus()
	menu_tween.tween_property($pause_menu, "scale", Vector2.ONE, 0.2)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	menu_tween.tween_property($pause_menu, "modulate:a", 1.0, 0.2)

func _close_pause_menu():
	$special_charge_bar.show()
	menu_tween.tween_property($pause_menu, "scale", Vector2.ZERO, 0.2)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	menu_tween.tween_property($pause_menu, "modulate:a", 0.0, 0.2)
	menu_tween.chain().tween_callback($pause_menu.hide)

func _on_resume_button_pressed() -> void:
	audiomanager.play_menu_sound(load("res://Assets/Sound_Effects/Menu_Sound.mp3"))
	_toggle_pause()
func _on_special_weapon_activated():
	$flash_screen.show()
	$flash_screen.modulate.a = 1.0
	await get_tree().create_timer(0.2).timeout
	var tween = create_tween()
	tween.tween_property($flash_screen, "modulate:a", 0.0, 1.0)
	tween.tween_callback($flash_screen.hide)
