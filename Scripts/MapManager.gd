extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	var inst = load("res://Levels/0.tscn").instantiate()
#
#	inst = load("res://Levels/1.tscn").instantiate()
#	inst.position = Vector2()
	randomize()
	var froms = $TileMap.doorways
	var most : = 0
	for i in froms:
		if i.x > most:
			most = i.x
	
	froms = froms.filter(func(a) : 
		return a.x == most
	)
	
	var from = froms[randi() % froms.size()]
	print(from)
	
	var tos = $TileMap2.doorways
	most = 0
	for i in tos:
		if i.x  < most:
			most = i.x
	
	tos = tos.filter(func(a) : 
		return a.x == most
	)
	
	var to = tos[randi() % tos.size()]
	
	for i in TileMap
	
	for i in range(($TileMap2.position.x - ($TileMap.position.x + $TileMap.size.x * 32)) / 32.0):
		#print(2)
		$TileMap.set_cell(0, Vector2i(from.x + i, from.y), 0, Vector2i(1, 0))
	
	
	
	$TileMap2.position.y += to.y - from.y * 32.0
			
	
	
	


func gen():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass
	
	
	
	
