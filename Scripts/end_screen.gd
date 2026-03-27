extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$replay_button.grab_focus()
	if gamemanager.health <= 0:
		$game_status_label.set_text("YOU DIED")
	elif gamemanager.score < 2000:
		$game_status_label.set_text("YOU LOST")
	elif gamemanager.score >= 2000:
		$game_status_label.set_text("YOU WON")
	$score_label.set_text("Score: " + str(gamemanager.score)) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_replay_button_pressed() -> void:
	gamemanager.restart_game()
