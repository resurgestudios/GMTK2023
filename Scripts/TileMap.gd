extends TileMap

var cleared : bool = false
var size : Vector2i
var doorways : Array[Vector2i]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !cleared && $Enemies.get_child_count() == 0:
		cleared = true
		for i in $Doors.get_children():
			i.get_node("CollisionShape2D").set_deferred("disabled", true)

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
	z_index = -5
	if !cleared:
		for i in $Doors.get_children():
			i.get_node("CollisionShape2D").set_deferred("disabled", false)


func _on_player_area_body_exited(body):
	z_index = -10
