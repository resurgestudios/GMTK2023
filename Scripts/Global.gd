extends Node2D

var rng = RandomNumberGenerator.new()
var root
var ink = null
var score: int = 0
var map: AStarGrid2D
var map_w : int = 1
var map_h : int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color(0, 0, 0))
	pass
#
#		await get_tree().create_timer(1).timeout	



var spawned = false
@export var ink_draw_rate: float = 1
@export var ink_draw_interval: float = 0.2
var timer: float = ink_draw_interval

func _process(delta):
	if not spawned:
		init_navigation()
		spawned = true
	if ink != null:
		timer -= delta
		if timer <= 0.0:
			timer = ink_draw_interval
			if ink.retrieve(ink_draw_rate) == 0:
				die()
			else:
				ink.redraw()
			
	
	

func spawn_normal_enemies():
	for i in range(0, 8):
		var normal_enemy_inst = load("res://Enemies/normal_enemy.tscn").instantiate()
		var x: int = round(rng.randf_range(0.0, 1920.0))
		var y: int = round(rng.randf_range(0.0, 1080.0))
		normal_enemy_inst.add_to_group("normal")
		normal_enemy_inst.position = Vector2(x, y)
		get_tree().root.add_child(normal_enemy_inst)

func spawn_boss_enemies():
	for i in range(0, 1):
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
		
func spawn_coffee_enemies():
	for i in range(0, 2):
		var coffee_enemy_inst = load("res://Enemies/coffee_enemy.tscn").instantiate()
		var x: int = round(rng.randf_range(0.0, 1920.0))
		var y: int = round(rng.randf_range(0.0, 1080.0))
		coffee_enemy_inst.add_to_group("coffee")
		coffee_enemy_inst.position = Vector2(x, y)
		get_tree().root.add_child(coffee_enemy_inst)
		
func die():
	print("you died, your score was ", score)
	pass

var cell_size: Vector2 = Vector2(64, 64)

func closest_point(xy: Vector2):
	xy -= map.offset
	var ij: Vector2i = Vector2i(floor(xy.x / cell_size.x), floor(xy.y / cell_size.y))
	return ij

func init_navigation():
	map = AStarGrid2D.new()
	map.region = Rect2i(-100, -100, 200, 200)
	map.cell_size = cell_size
	map.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	map.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	map.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	map.update()
