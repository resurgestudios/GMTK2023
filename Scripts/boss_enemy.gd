extends CharacterBody2D


const speed: float = 50
var target_velocity: Vector2

func _ready():
	pass

var timer: float = 0

func bounce(collision: KinematicCollision2D):
	var norm: Vector2 = collision.get_normal()
	var lengthA: float = max(20, target_velocity.length())
	var lengthB: float = max(20, collision.get_collider_velocity().length())
	var length: float = min(speed/2.0, sqrt(lengthA * lengthB))
	var dir: Vector2 = target_velocity.bounce(norm).normalized()
	target_velocity = dir * length

func _physics_process(delta):
	timer -= delta
	velocity = target_velocity
	if timer <= 0:
		var cur: Vector2i = Global.closest_point(position)
		var end: Vector2i = Global.closest_point(get_node("/root/Main/Printer").position)
		var path: PackedVector2Array = Global.map.get_point_path(cur, end)
		if len(path) > 1:
			var next: Vector2 = path[1]
			target_velocity = (next - position).normalized() * speed
		timer = Global.rng.randf_range(0.75, 1.25)
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision != null:
		if not collision.get_collider().is_in_group("enemy"):
			bounce(collision)


