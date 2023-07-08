extends Node2D

var rng = RandomNumberGenerator.new()
var root
var map: AStarGrid2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#
#		await get_tree().create_timer(1).timeout	

var spawned = false

func _process(_delta):
	if not spawned:
		spawn_normal_enemies()
		spawn_boss_enemies()
		init_navigation()
		spawned = true
		

func spawn_normal_enemies():
	for i in range(0, 8):
		var normal_enemy_inst = load("res://Enemies/normal_enemy.tscn").instantiate()
		var x: int = round(rng.randf_range(0.0, 1920.0))
		var y: int = round(rng.randf_range(0.0, 1080.0))
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
	print("pos", map.get_point_position(Vector2i(1, 3)))
