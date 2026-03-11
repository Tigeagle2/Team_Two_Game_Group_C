extends Area2D
@export var enemy_spawn_limit: int = 1
@export var spawn_frequency: float = 1.0
var enemy_scene = preload("res://Scenes/basic_enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(enemy_spawn_limit):
		var enemy = enemy_scene.instantiate()
		add_child(enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
