extends CharacterBody2D

func _ready():
	var angle = position.angle_to_point(get_local_mouse_position())
#	velocity.y = 1200 * sin(angle)
#	velocity.x = 1200 * cos(angle)
	
func _physics_process(delta):
	velocity *= 0.99
	var col = move_and_collide(velocity * delta)
	if col:
		if col.get_collider().is_in_group("enemies"):
			col.get_collider().queue_free()
	
	if velocity == Vector2.ZERO:
		queue_free()


func _on_timer_timeout():
	queue_free()
	

	
	
