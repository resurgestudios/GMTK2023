extends CharacterBody2D
	
var threshold: float = 50.0
var angular_velocity: float = 1.0
	
func _ready():
	angular_velocity = Global.rng.randf_range(PI/4.0, PI/2.0)
	
func _physics_process(delta):
	velocity *= 0.98
	angular_velocity *= 0.98
	rotation += delta * angular_velocity
	if velocity.length() < threshold:
		queue_free()
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision != null:
		if not collision.get_collider().is_in_group("enemies"):
			queue_free()

func _on_timer_timeout():
	queue_free()


