extends CharacterBody2D
	
func _physics_process(delta):
	velocity *= 0.98
	move_and_collide(velocity * delta)
	if velocity == Vector2.ZERO:
		queue_free()

func _on_timer_timeout():
	queue_free()
	

	
	
