extends CharacterBody2D

func _ready():
	var angle = position.angle_to_point(get_local_mouse_position())
#	velocity.y = 1200 * sin(angle)
#	velocity.x = 1200 * cos(angle)
	
func _physics_process(delta):
	move_and_collide(velocity * delta)


# func _on_timer_timeout():
# 	queue_free()
