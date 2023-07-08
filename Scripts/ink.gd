extends CharacterBody2D

func _ready():
	var angle = position.angle_to_point(get_local_mouse_position())
#	velocity.y = 1200 * sin(angle)
#	velocity.x = 1200 * cos(angle)
	
func _physics_process(delta):
	velocity *= 0.99
	move_and_collide(velocity * delta)
	if velocity == Vector2.ZERO:
		queue_free()


func _on_timer_timeout():
	queue_free()
	

	
	
