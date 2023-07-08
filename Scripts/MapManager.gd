extends Node2D

@export var map_w : int = 2
@export var map_h : int = 2
const section_w : int = 12 # default width and height for 1x1 section
const section_h : int = 12

var map = []
var empty_map = []

var sections : Dictionary = {}

class Section:
	var x : int = 0
	var y : int = 0
	var w : int = 0
	var h : int = 0
	var doorways : Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0, map_h):
		map.append([])
		for j in range(0, map_w):
			map[map.size() - 1].append(0)
			empty_map.append([i, j])
	gen()


func gen():
	# TODO make random picking from empty taken maps instead of left to right up to down
	randomize()
	while true:
		if empty_map.size() == 0:
			break
		
		var ind = empty_map[randi() % empty_map.size()]
		create_section(ind[0], ind[1])


func create_section(x, y):
	var possible_sizes = [[1,1]]
	
	#2x1
	if empty_map.has([x+1, y]):
		possible_sizes.append([2, 1])
	
	#1x2
	if empty_map.has([x, y + 1]):
		possible_sizes.append([1, 2])
	
	#2x2
	if empty_map.has([x, y+1]) && empty_map.has([x+1, y]) && empty_map.has([x+1, y + 1]):
		possible_sizes.append([2, 2])
	
	#2x3
	var flag: bool = true
	for i in range(0, 2):
		for j in range(0, 3):
			if !empty_map.has([x + i, y + j]):
				flag = false
	
	if flag:
		possible_sizes.append([2,3])
	
	#3x2
	flag = true
	for i in range(0, 3):
		for j in range(0, 2):
			if !empty_map.has([x + i, y + j]):
				flag = false
	
	if flag:
		possible_sizes.append([3,2])
	
	#3x3
	flag= true
	for i in range(0, 3):
		for j in range(0, 3):
			if !empty_map.has([x + i, y + j]):
				flag = false
				
	if flag:
		possible_sizes.append([3,3])
		
	
	var weight : float = 1
	var weights = []
	for i in possible_sizes:
		weights.append(weight)
		weight *= 2.0
	
	var size : Array = possible_sizes[weighted_random(weights)]
	
	
	var str : String = "res://Levels/" + str(size[0]) + "x" + str(size[1]) + "/"
	var paths : = DirAccess.get_files_at("res://Levels/" + str(size[0]) + "x" + str(size[1]))
	
	str += paths[randi() % paths.size()]
	
	match size:
		[1, 1]:
			empty_map.erase([x, y])
		[1, 2]:
			empty_map.erase([x, y])
			empty_map.erase([x, y + 1])
		[2, 1]:
			empty_map.erase([x, y])
			empty_map.erase([x+1, y])
		[2, 2]:
			for i in range(2, 2):
				for j in range(0, 3):
					empty_map.erase([x+i, y+j])
		[2,3]:
			for i in range(0, 2):
				for j in range(0, 3):
					empty_map.erase([x+i, y+j])
		[3,2]:
			for i in range(0, 3):
				for j in range(0, 2):
					empty_map.erase([x+i, y+j])
		[3,3]:
			for i in range(0, 3):
				for j in range(0, 3):
					empty_map.erase([x+i, y+j])
				
	
	
	
	var inst = load(str).instantiate()
	for i in inst.get_used_cells(0):
		var coords = inst.get_cell_atlas_coords(0, Vector2i(i.x, i.y))
		$TileMap.set_cell(0, Vector2i(x * 12 +i.x, y * 12+i.y), 0, coords)
		
	
	inst.queue_free()
	


func weighted_random(weights):
	randomize()
	var weights_sum := 0.0
	for weight in weights:
		weights_sum += weight
	
	var remaining_distance := randf() * weights_sum
	for i in weights.size():
		remaining_distance -= weights[i]
		if remaining_distance < 0:
			return i
	
	return 0
	
	
	
