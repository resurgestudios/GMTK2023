extends CharacterBody2D

@export var ink_speed: int = 200
@export var ink_cost: float = 5
var max_jump_dist: float = 500
var frozen: bool = false
var move_time: float = 0.0
var total_move_time: float = 0.5
var target_velocity: Vector2 = Vector2.ZERO
var start_position: Vector2 = Vector2.ZERO
var end_position: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var frozen_timer: float = 3.0

func _ready():
	start_position = position
	end_position = position
	target_position = position
	move_time = total_move_time

# t: a value between 0 and 1, the progress of the movement
# return: a multiplier for the velocity to be multiplied by
# https://www.desmos.com/calculator/z4vglvnbqo to find a,b,c
var a: float = 1.0
var b: float = 1.0
var c: float = 0.5
func easing(t: float) -> float:
	var s: float = 1 - t
#	print(t, s*s*a + s*t*b + t*s*b + t*t*c)
	return s*s*a + s*t*b + t*s*b + t*t*c

func _process(delta: float):
	if move_time >= total_move_time:
		$AnimatedSprite2D.stop() # change this to play idle animation
		if Input.is_action_just_pressed("Jump"):
			$AnimatedSprite2D.play("jump")
			target_velocity = Vector2.ZERO
			start_position = position
			end_position = get_global_mouse_position()
			var vec: Vector2 = (end_position - start_position)
			var magnitude: float = min(max_jump_dist, vec.length())
			vec = vec.normalized() * magnitude
			end_position = start_position + vec
			move_time = 0.0
	if Input.is_action_just_pressed("Shoot"):
		shoot_ink()
		
func shoot_ink():
	if Global.ink.total_volume() >= ink_cost and frozen == false:
		var ink_inst = load("res://Scenes/ink.tscn").instantiate()
		get_tree().root.add_child(ink_inst)
		var angle = position.angle_to_point(get_global_mouse_position())
		ink_inst.velocity.y = ink_speed * sin(angle)
		ink_inst.velocity.x = ink_speed * cos(angle)
		ink_inst.position = position
		ink_inst.rotation = angle
		if Global.ink.queue[0].is_ink:
			ink_inst.get_node("Black").show()
			ink_inst.get_node("Red").hide()
		else:
			ink_inst.get_node("Red").show()
			ink_inst.get_node("Black").hide()
		Global.ink.retrieve(ink_cost)
		
		
func bounce(collision: KinematicCollision2D):
	var norm: Vector2 = collision.get_normal()
	var lengthA: float = max(200, target_velocity.length())
	var lengthB: float = max(200, collision.get_collider_velocity().length())
	var length: float = sqrt(lengthA * lengthB)
	var dir: Vector2 = target_velocity.bounce(norm).normalized()
	target_velocity = dir * length

func _physics_process(delta):
	move_time += delta
	if move_time <= total_move_time:
		target_position = start_position.lerp(end_position, move_time / total_move_time)
		var vec: Vector2 = Vector2.ZERO
		if target_velocity.length() < 1:
			vec = target_position - position
			target_velocity = vec / delta
		else:
			vec = target_velocity * delta
#		print(start_position, end_target_position)
		var collision: KinematicCollision2D = move_and_collide(vec)
		if collision != null and not collision.get_collider().is_in_group("enemies"):
			bounce(collision)
	if frozen == true:
		frozen_timer -= delta
	if frozen_timer <= 0.0:
		frozen = false

func touch_coffee():
	Global.ink.retrieve(100)
	frozen = true
	frozen_timer = 3.0
	
	
