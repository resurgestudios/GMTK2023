extends TileMap

var cleared : bool = false
var size : Vector2i
var doorways : Array[Vector2i]
var p_entered : bool = false
var no_enemies : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if $Enemies.get_child_count() == 0:
		no_enemies = true
	init()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !cleared && $Enemies.get_child_count() == 0 && p_entered:
		cleared = true
		if !no_enemies:
			Global.root.get_node("Printer/Camera2D/AnimationPlayer").play_backwards("zoom_in")
		for i in $Doors.get_children():
			i.get_node("CollisionShape2D").set_deferred("disabled", true)
			Global.root.get_node("Printer/Camera2D/AnimationPlayer").play_backwards("zoom_in")



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
		if $Enemies.get_child_count() > 0:
			Global.root.get_node("Printer/Camera2D/AnimationPlayer").play("zoom_in")
		for i in $Enemies.get_children():
			i.activate()
		$Shade/AnimationPlayer.play("Fade")
		for i in $Doors.get_children():
			i.get_node("CollisionShape2D").set_deferred("disabled", false)


func _on_player_area_body_exited(body):
	p_entered = false
	z_index = -10

