extends Node2D

var rng = RandomNumberGenerator.new()
var root

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#
#		await get_tree().create_timer(1).timeout	

var spawned = false
var ink: float = 1.0
@export var ink_draw_rate: float = 2

func _process(delta):
	if not spawned:
		spawn_normal_enemies()
		spawn_boss_enemies()
		spawn_hacker_enemies()
		spawned = true
		
func _physics_process(delta):
	ink -= ink_draw_rate * 0.01 * delta;
	if ink <= 0:
		die()
	
	

func spawn_normal_enemies():
	for i in range(0, 8):
		var normal_enemy_inst = load("res://Enemies/normal_enemy.tscn").instantiate()
		var x: int = round(rng.randf_range(0.0, 1920.0))
		var y: int = round(rng.randf_range(0.0, 1080.0))
		normal_enemy_inst.add_to_group("normal")
		normal_enemy_inst.position = Vector2(x, y)
		get_tree().root.add_child(normal_enemy_inst)

func spawn_boss_enemies():
	for i in range(0, 2):
		var boss_enemy_inst = load("res://Enemies/boss_enemy.tscn").instantiate()
		var x: int = round(rng.randf_range(0.0, 1920.0))
		var y: int = round(rng.randf_range(0.0, 1080.0))
		boss_enemy_inst.add_to_group("boss")
		boss_enemy_inst.position = Vector2(x, y)
		get_tree().root.add_child(boss_enemy_inst)
		
func spawn_hacker_enemies():
	for i in range(0, 2):
		var hacker_enemy_inst = load("res://Enemies/hacker_enemy.tscn").instantiate()
		var x: int = round(rng.randf_range(0.0, 1920.0))
		var y: int = round(rng.randf_range(0.0, 1080.0))
		hacker_enemy_inst.add_to_group("hacker")
		hacker_enemy_inst.position = Vector2(x, y)
		get_tree().root.add_child(hacker_enemy_inst)
		
func die():
	pass

