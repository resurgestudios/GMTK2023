extends Node2D


func _on_area_2d_body_entered(body):
	if body.is_in_group("printer"):
		Global.ink.add(true, 150)
		queue_free()
