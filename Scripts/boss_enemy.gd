extends CharacterBody2D


const speed: int = 50
var rng = RandomNumberGenerator.new()
var direction: float = rng.randf_range(0, 2 * PI)
var target_velocity: Vector2

func bounce_with_clamp(min_length: float, max_length: float):
	var collision: KinematicCollision2D = get_last_slide_collision()
	var norm: Vector2 = collision.get_normal()
	var length: float = target_velocity.length()
	var dir: Vector2 = target_velocity.bounce(norm).normalized()
	length = clamp(length, min_length, max_length)
	target_velocity = dir * length

func _ready():
	pass

var timer: float = 0

func _physics_process(delta):
	velocity = target_velocity
	timer -= delta
	if timer <= 0:
		direction += rng.randf_range(-1.0, 1.0)
		timer = rng.randf_range(1.5, 3.0)
		target_velocity = speed * Vector2(cos(direction), sin(direction))
	if move_and_slide():
		bounce_with_clamp(200, 2000)


