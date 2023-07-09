extends Node2D

var printer: Node2D = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if printer == null:
		if Global.root != null:
			printer = Global.root.get_node("Printer")
	else:
		var mouse_pos: Vector2 = get_global_mouse_position()
		var printer_pos: Vector2 = printer.global_position
		var vector: Vector2 = mouse_pos - printer_pos
		var length: float = min(vector.length(), printer.max_jump_dist)
		position = printer_pos + vector.normalized() * length
		rotation += delta
