extends TileMap

var cleared : bool = false
var size : Vector2i
var doorways : Array[Vector2i]
var p_entered : bool = false
var no_enemies : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0
	if $Enemies.get_child_count() == 0:
		no_enemies = true
	init()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !cleared && $Enemies.get_child_count() == 0 && p_entered:
		var tmap = Global.root.get_node("MapManager")
		tmap.curr_section_count += 1
		if tmap.curr_section_count == tmap.section_count:
			tmap.next_stage()
			
			
		cleared = true
		if !no_enemies:
			Global.root.get_node("Printer/Camera2D/AnimationPlayer").play_backwards("zoom_in")
		for i in $Doors.get_children():
			i.get_node("CollisionShape2D").set_deferred("disabled", true)
			i.get_node("AnimatedSprite2D").play("default")
		
		for i in get_tree().get_nodes_in_group("section"):
			if i == self:
				continue
			if i.modulate.a == 1:
				continue
			if i.cleared:
				i.get_node("TMAnimationPlayer").play("Fade")
		
#		for i in get_used_cells(0):
#			if get_cell_atlas_coords(0, i) in [Vector2i(20, 9), Vector2i(21, 9)]:
#				set_cell(0, i, 0, Vector2i(22, 9))



func init():
	var w : int = 0
	var h : int = 0
	
	for i in get_used_cells(0):
		if i.x > w:
			w = i.x
		if i.y > h:
			h = i.y
	size = Vector2i(w, h)
	
	doorways = get_used_cells_by_id(0, 0, Vector2i(2, 0))


func _on_player_area_body_entered(body):
	p_entered = true
	z_index = -5
	if !cleared:
#		Global.root.get_node("Printer").position += "Area2D"
		if $Enemies.get_child_count() > 0:
			Global.root.get_node("Printer/Camera2D/AnimationPlayer").play("zoom_in")
		for i in $Enemies.get_children():
			i.activate()
		$TMAnimationPlayer.play("Fade")
		if !no_enemies:
			for i in get_tree().get_nodes_in_group("section"):
				if i == self:
					continue
				if i.modulate.a == 0:
					continue
				i.get_node("TMAnimationPlayer").play_backwards("Fade")
			
		for i in $Doors.get_children():
			i.get_node("CollisionShape2D").set_deferred("disabled", false)
			i.get_node("AnimatedSprite2D").play_backwards("default")
		
		


func _on_player_area_body_exited(body):
	p_entered = false
	z_index = -10
	

