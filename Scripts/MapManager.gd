extends Node2D

@export var map_w : int = 3
@export var map_h : int = 3
@export var variance : float = 4.0 # lower means higher chance of smaller grid blocks
const section_w : int = 12 # default width and height for 1x1 section
const section_h : int = 12
const tile_w : int = 16
const tile_h : int = 16

var section_count : int = 0
var curr_section_count : int = 0

var map = []
var empty_map = []

var sections : Dictionary = {}

class Section:
	var x : int = 0
	var y : int = 0
	var w : int = 0
	var h : int = 0
	var doorways : Dictionary = {}

signal update_cam_bounds


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_w = Global.map_w
	map_h = Global.map_h
	
	for i in range(0, map_h):
		map.append([])
		for j in range(0, map_w):
			map[map.size() - 1].append(0)
			empty_map.append([i, j])
	gen()
	

func gen():
	randomize()
	while true:
		#print(empty_map)
		if empty_map.size() == 0:
			break
		
		section_count += 1
		var ind = empty_map[randi() % empty_map.size()]
		create_section(ind[0], ind[1])
		#update_cam_bounds.emit((section_w + (map_w - 1) * (section_w - 1)) * tile_w * scale.x, 
		#			(section_h + (map_h - 1) * (section_h - 1)) * tile_h * scale.y)
		
	$TileMap.queue_free()


func create_section(x, y):
	var possible_sizes = [[1,1]]
	var possible_poses = [[x, y]]
	var tx
	var ty
	
#	#2x1
#	for i in range(0, 2):
#		ty = y - i
#		if empty_map.has([x, ty]) && empty_map.has([x+1, ty]):
#			possible_sizes.append([2, 1])
#			possible_poses.append([x, ty])
	
	#1x2
	for i in range(0, 2):
		tx = x - i
		if empty_map.has([tx, y]) && empty_map.has([tx, y + 1]):
			possible_sizes.append([1, 2])
			possible_poses.append([tx, y])
	
	#2x2
	for i in range(0, 2):
		for j in range(0, 2):
			tx = x - i
			ty = y - j
			if tx < 0 || ty < 0:
				continue
			
			if empty_map.has([tx, ty]) && empty_map.has([tx, ty+1]) && empty_map.has([tx+1, ty]) && empty_map.has([tx+1, ty + 1]):
				possible_sizes.append([2, 2])
				possible_poses.append([tx, ty])
	
	
	var flag: bool = true
	
	#2x3
	for a in range(0, 2):
		for b in range(0, 3):
			tx = x - a
			ty = y - b
			if tx < 0 || ty < 0:
				continue
			
			flag = true
			for i in range(0, 2):
				for j in range(0, 3):
					if !empty_map.has([tx, ty]) || !empty_map.has([tx + i, ty + j]):
						flag = false
			
			if flag:
				possible_sizes.append([2,3])
				possible_poses.append([tx, ty])
	
	#3x2
	for a in range(0, 3):
		for b in range(0, 2):
			tx = x - a
			ty = y - b
			if tx < 0 || ty < 0:
				continue
			
			flag = true
			for i in range(0, 3):
				for j in range(0, 2):
					if !empty_map.has([tx, ty]) || !empty_map.has([tx + i, ty + j]):
						flag = false
			
			if flag:
				possible_sizes.append([3,2])
				possible_poses.append([tx, ty])
	
	#3x3
	for a in range(0, 3):
		for b in range(0, 3):
			tx = x - a
			ty = y - b
			if tx < 0 || ty < 0:
				continue
				
			flag = true
			for i in range(0, 3):
				for j in range(0, 3):
					if !empty_map.has([tx, ty]) || !empty_map.has([tx + i, ty + j]):
						flag = false
						
			if flag:
				possible_sizes.append([3,3])
				possible_poses.append([tx, ty])
		
	
	var weight : float = 0.5
	var weights = []
	var last
	for i in possible_sizes:
		if i[0] * i[1] != last:
			weight *= variance

		last = i[0] * i[1]
		weights.append(weight)
	
	weighted_random(weights)
	var ind = weighted_random(weights)
	var size : Array = possible_sizes[ind]
	var pos = possible_poses[ind]
#	print("s:", possible_sizes)
#	print("p:", possible_poses)
#	print("w:", weights)
	
	var str : String = "res://Levels/" + str(size[0]) + "x" + str(size[1]) + "/"
	var paths : = DirAccess.get_files_at("res://Levels/" + str(size[0]) + "x" + str(size[1]))
	var new_paths : Array = []
	for i in range(0, paths.size()):
		if paths[i].ends_with(".tscn"):
			new_paths.append(paths[i])
	
	paths = new_paths
	
	str += paths[randi() % paths.size()]
	
	
	match size:
		[1, 1]:
			empty_map.erase([pos[0], pos[1]])
		[1, 2]:
			empty_map.erase([pos[0], pos[1]])
			empty_map.erase([pos[0], pos[1] + 1])
		[2, 1]:
			empty_map.erase([pos[0], pos[1]])
			empty_map.erase([pos[0]+1, pos[1]])
		[2, 2]:
			for i in range(0, 2):
				for j in range(0, 2):
					empty_map.erase([pos[0]+i, pos[1]+j])
		[2,3]:
			for i in range(0, 2):
				for j in range(0, 3):
					empty_map.erase([pos[0]+i, pos[1]+j])
		[3,2]:
			for i in range(0, 3):
				for j in range(0, 2):
					empty_map.erase([pos[0]+i, pos[1]+j])
		[3,3]:
			for i in range(0, 3):
				for j in range(0, 3):
					empty_map.erase([pos[0]+i, pos[1]+j])
				
	
	
	
	var inst = load(str).instantiate()
	add_child(inst)
	inst.position = Vector2(pos[0] * (section_w - 1) * tile_w, pos[1] * (section_h - 1) * tile_h)
	
	#inst.hide()
	
	for i in inst.get_used_cells(0):
		var a_coords = inst.get_cell_atlas_coords(0, Vector2i(i.x, i.y))
		
		#edges of map no doors
		if pos[0] == 0:
			if i.x == 0:
				a_coords = Vector2i(21, 9)
				inst.set_cell(0, Vector2i(i.x, i.y), 0, a_coords)
				for c in inst.get_node("Doors").get_children():
					if c.get_meta("Dir") == "left":
						c.queue_free()
		
		if pos[1] == 0:
			if i.y == 0 && i.x != 0 && i.x != section_w - size[0]:
				a_coords = Vector2i(0, 0)
				inst.set_cell(0, Vector2i(i.x, i.y), 0, a_coords)
				inst.set_cell(0, Vector2i(i.x, i.y + 1), 0, Vector2i(0, 1))
				for c in inst.get_node("Doors").get_children():
					if c.get_meta("Dir") == "up":
						c.queue_free()
		
		if pos[0] * section_w + i.x == map_w * section_w - size[0]:
			a_coords = Vector2i(20, 9)
			inst.set_cell(0, Vector2i(i.x, i.y), 0, a_coords)
			for c in inst.get_node("Doors").get_children():
				if c.get_meta("Dir") == "right":
					c.queue_free()
			
		
		if pos[1] * section_h + i.y == map_h * section_h - size[1]:
			a_coords = Vector2i(20, 11)
			inst.set_cell(0, Vector2i(i.x, i.y), 0, a_coords)
			for c in inst.get_node("Doors").get_children():
				if c.get_meta("Dir") == "down":
					c.queue_free()
			
		if pos[0] != 0:
			i.x -= pos[0]
			
		if pos[1] != 0:
			i.y -= pos[1]
		
		
		
		$TileMap.set_cell(0, Vector2i(pos[0] * section_w + i.x, pos[1] * section_h + i.y), 0, a_coords)
		
	#inst.queue_free()

func next_stage():
	Global.map_w += 1
	Global.map_h += 1
	Global.save_bgm()
	for child in get_node("/root/Main/Splashes").get_children():
		if child.is_in_group("blood"):
			Global.ink.add(false, child.volume)
	Global.save_ink()
	get_tree().reload_current_scene()


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
	
