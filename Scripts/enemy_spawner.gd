extends Area2D
enum EnemyType {BasicEnemy, RangedEnemy}

@export var selected_enemy: EnemyType
## If true, the spawner is active at all times
@export var always_active: bool = false
## If true, the spawner will use a random spawn system instead of an interval system
@export var random_spawn: bool = false
## If true, the spawner only spawns while on screen
@export var spawn_while_on_screen: bool = false
## If true, a full group spawns even if it puts it over the spawn limit. 
## If false, the amount of enemies from one spawner will never exced its spawn limit
@export var group_bypass_limit: bool = false
@export var enemy_spawn_limit: int = 50
## How many enemies spawn at once
@export var spawn_group_size: int = 3
## The amount of enemies that spawn at the start of the game
@export var amount_at_start: int = 5
## How long after the spawner activates before its spawn logic starts up again
@export var activation_cooldown: float = 2.0
## The amount of pixels the enemys can randomlly spawn in either direction
@export var enemy_spawn_range: float = 100
@export_group("Interval Spawning")
## Time between spawn attemps
@export var spawn_interval: float = 5.0
@export_group("Random Spawning")
## Time between spawn attempts
@export var roll_time_gap: float = 1.0
## Chance for an enemy to spawn every time the dice is rolled
@export_range(0, 100, 0.1, "suffix:%") var spawn_chance: float = 10.0

var enemy_scenes = {
	EnemyType.BasicEnemy: preload("res://Scenes/basic_enemy.tscn"),
	EnemyType.RangedEnemy: preload("res://Scenes/ranged_enemy.tscn")
}
var spawner_active: bool = false
var spawn_timer
var enemy_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_scene = enemy_scenes[selected_enemy]
	spawn_enemy(amount_at_start)
	if random_spawn:
		spawn_timer = roll_time_gap
	else:
		spawn_timer = spawn_interval
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawner_active || always_active:
		if random_spawn:
			if spawn_timer <= 0:
				var rand_roll = randf_range(0, 100)
				if rand_roll < spawn_chance:
					attempt_enemy_spawn()
				spawn_timer = roll_time_gap
			else:
				spawn_timer -= delta
		else:
			if spawn_timer <= 0:
				spawn_timer = spawn_interval
				attempt_enemy_spawn()
			else:
				spawn_timer -= delta
func attempt_enemy_spawn():
	var current_amount_of_enemies = self.get_child_count()
	if current_amount_of_enemies >= enemy_spawn_limit:
		return
	if group_bypass_limit:
		spawn_enemy(spawn_group_size)
	else:
		var space_left = enemy_spawn_limit - current_amount_of_enemies
		spawn_enemy(min(spawn_group_size, space_left))
func spawn_enemy(amount: int):
	for i in range(amount):
		var enemy = enemy_scene.instantiate()
		enemy.setup(enemy_spawn_range, enemy_spawn_range)
		add_child(enemy)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if !spawn_while_on_screen:
		spawner_active = false
	else:
		spawner_active = true
		spawn_timer = activation_cooldown


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if !spawn_while_on_screen:
		spawner_active = true
		spawn_timer = activation_cooldown
	else:
		spawner_active = false
	
