extends CharacterBody2D
	
var rng = RandomNumberGenerator.new()
var threshold: float = 20.0
var angular_velocity: float = 1.0
	
func _ready():
	angular_velocity = Global.rng.randf_range(PI/4.0, PI/2.0)
	var random = rng.randi_range(0, 5)
	if random == 0:
		$Sprite1.show()
		$Sprite2.hide()
		$Sprite3.hide()
		$Sprite4.hide()
		$Sprite5.hide()
		
	elif random == 1:
		$Sprite2.show()
		$Sprite1.hide()
		$Sprite3.hide()
		$Sprite4.hide()
		$Sprite5.hide()
		
	elif random == 2:
		$Sprite3.show()
		$Sprite1.hide()
		$Sprite3.hide()
		$Sprite4.hide()
		$Sprite5.hide()
		
	elif random == 3:
		$Sprite4.show()
		$Sprite1.hide()
		$Sprite3.hide()
		$Sprite4.hide()
		$Sprite5.hide()
	
	elif random == 4:
		$Sprite5.show()
		$Sprite2.hide()
		$Sprite1.hide()
		$Sprite3.hide()
		$Sprite4.hide()
		
	
func _physics_process(delta):
	velocity *= 0.99
	angular_velocity *= 0.99
	rotation += delta * angular_velocity
	if velocity.length() < threshold:
		queue_free()
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision != null:
		if not collision.get_collider().is_in_group("enemies"):
			queue_free()

func _on_timer_timeout():
	queue_free()


