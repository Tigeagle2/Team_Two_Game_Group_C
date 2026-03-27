extends Button

@onready var button_hover: AudioStreamPlayer = %ButtonHover
var label: Label

func _ready():
	for child in get_children():
		if child is Label:
			label = child
			break
	
	if label and label.material:
		label.material = label.material.duplicate()
		label.material.set_shader_parameter("hover_intensity", 1.0)

func _on_mouse_entered() -> void:
	if button_hover:
		button_hover.play()
	_tween_intensity(3.0)

func _on_mouse_exited() -> void:
	_tween_intensity(1.0)

func _tween_intensity(target: float) -> void:
	if not label or not label.material:
		return
	var tween = create_tween()
	tween.tween_property(
		label.material,
		"shader_parameter/hover_intensity",
		target,
		0.3
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_pressed() -> void:
	button_hover.play()
	get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")
