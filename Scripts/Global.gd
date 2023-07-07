extends Node2D

var rng = RandomNumberGenerator.new()
var root

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#
#		await get_tree().create_timer(1).timeout	

var spawned = false
func _process(delta):
	if not spawned:
		for i in range(0, 5):
			var normal_enemy_inst = load("res://Enemies/enemy.tscn").instantiate()
			var x: int = round(rng.randf_range(0.0, 1920.0))
			var y: int = round(rng.randf_range(0.0, 1080.0))
			normal_enemy_inst.position = Vector2(x, y)
			get_tree().root.add_child(normal_enemy_inst)
		spawned = true

