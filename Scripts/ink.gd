extends CharacterBody2D
	
var threshold: float = 20.0
	
func _physics_process(delta):
	velocity *= 0.98
	if move_and_collide(velocity * delta) or velocity.length() < threshold:
		queue_free()

func _on_timer_timeout():
	queue_free()


