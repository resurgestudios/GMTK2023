extends TileMap

var size : Vector2i
var doorways : Array[Vector2i]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var w : int = 0
	var h : int= 0
	
	for i in get_used_cells(0):
		if i.x > w:
			w = i.x
		if i.y > h:
			h = i.y
	size = Vector2i(w, h)
	
	doorways = get_used_cells_by_id(0, 0, Vector2i(2, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass
