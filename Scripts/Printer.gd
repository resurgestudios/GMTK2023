extends CharacterBody2D

@export var max_time: float = 2
@export var threshold: float = 0.1
@export var bounce: bool = true
@export var base_move_time: float = 0.5
@export var multiplier: float = 1000

var action_time: float = 0
var move_time: float = 0
var target_velocity: Vector2 = Vector2.ZERO

func _ready():
	pass

# t: a value between 0 and 1, the progress of the movement
# return: a multiplier for the velocity to be multiplied by
# https://www.desmos.com/calculator/z4vglvnbqo to find a,b,c
var a: float = 0.5
var b: float = 1.5
var c: float = 0.5
func easing(t: float) -> float:
	var s: float = 1 - t
	print(t, s*s*a + s*t*b + t*s*b + t*t*c)
	return s*s*a + s*t*b + t*s*b + t*t*c

func _process(delta: float):
	if move_time == 0:
		if Input.is_action_pressed("Jump"):
			action_time += delta
		if Input.is_action_just_released("Jump"):
			if action_time > threshold:
				$AnimatedSprite2D.play("jump")
				var direction: Vector2 = (get_global_mouse_position() - position).normalized()
				action_time = min(action_time, max_time)
				target_velocity = direction * action_time * multiplier
				move_time = base_move_time
			action_time = 0	
	if move_time < 0:
		if move_time < 0:
			target_velocity = Vector2.ZERO
			move_time = 0
			$AnimatedSprite2D.stop()
	if Input.is_action_just_pressed("Shoot"):
		var ink_inst = load("res://Scenes/ink.tscn").instantiate()
		get_tree().root.add_child(ink_inst)
		var angle = position.angle_to_point(get_global_mouse_position())
		ink_inst.velocity.y = 1200 * sin(angle)
		ink_inst.velocity.x = 1200 * cos(angle)
		ink_inst.position = position
		ink_inst.rotation = angle

func bounce_with_clamp(min_length: float, max_length: float):
	var collision: KinematicCollision2D = get_last_slide_collision()
	var norm: Vector2 = collision.get_normal()
	var length: float = target_velocity.length()
	var dir: Vector2 = target_velocity.bounce(norm).normalized()
	length = clamp(length, min_length, max_length)
	target_velocity = dir * length

func _physics_process(delta):
	var t: float = (base_move_time - move_time) / base_move_time
	velocity = target_velocity * easing(t)
	if move_time > 0:
		move_time -= delta
	if move_and_slide() and bounce:
		bounce_with_clamp(200, 2000)


	
