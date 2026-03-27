extends Button

@onready var exittext: Label = $Exittext
@onready var button_hover_2: AudioStreamPlayer = %ButtonHover2

func _ready():
	if exittext.material:
		exittext.material.set_shader_parameter("hover_intensity", 1.0)

func _on_Button_mouse_entered():
	if button_hover_2:
		button_hover_2.play()
	
	if exittext.material:
		var tween = create_tween()
		tween.tween_property(
			exittext.material,
			"shader_parameter/hover_intensity",
			3.0,
			0.3
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_Button_mouse_exited():
	if exittext.material:
		var tween = create_tween()
		tween.tween_property(
			exittext.material,
			"shader_parameter/hover_intensity",
			1.0,
			0.3
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
