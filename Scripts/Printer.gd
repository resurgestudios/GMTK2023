extends CharacterBody2D

@export var ink_speed: float = 300
@export var ink_cost: float = 5
var max_jump_dist: float = 120
var frozen: bool = false
var move_time: float = 0.0
var total_move_time: float = 0.5
var target_velocity: Vector2 = Vector2.ZERO
var start_position: Vector2 = Vector2.ZERO
var end_position: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var frozen_timer: float = 3.0
var ink_timer: float = 0.0
var splash_timer: float = 0.0
var dead: bool = false

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
		if Input.is_action_just_pressed("Jump") and not frozen:
			$AnimatedSprite2D.play("jump")
			$SFX/Move.play()
			target_velocity = Vector2.ZERO
			start_position = global_position
			end_position = get_global_mouse_position()
			var vec: Vector2 = (end_position - start_position)
			var magnitude: float = min(max_jump_dist, vec.length())
			vec = vec.normalized() * magnitude
			end_position = start_position + vec
			move_time = 0.0
	ink_timer -= delta
	splash_timer -= delta
	if Input.is_action_pressed("Shoot") and not frozen:
		if ink_timer <= 0.0:
			shoot_ink()
			ink_timer = 0.3
	if Input.is_action_pressed("Splash") and not frozen:
		if splash_timer <= 0.0:
			splash_ink()
			splash_timer = 1.0
		
func shoot_ink():
	if Global.ink.total_volume() >= ink_cost:
		var ink_inst = load("res://Scenes/ink.tscn").instantiate()
		Global.root.get_node("Splashes").add_child(ink_inst)
		var angle = global_position.angle_to_point(get_global_mouse_position())
		angle += Global.rng.randf_range(-0.1, 0.1)
		ink_inst.velocity.y = ink_speed * sin(angle)
		ink_inst.velocity.x = ink_speed * cos(angle)
		ink_inst.global_position = global_position
		ink_inst.rotation = angle
		if Global.ink.queue[0].is_ink:
			ink_inst.get_node("Black").show()
			ink_inst.get_node("Red").hide()
		else:
			ink_inst.get_node("Red").show()
			ink_inst.get_node("Black").hide()
		Global.ink.retrieve(ink_cost)
		$SFX/ShootPaper.play()
		
func splash_ink():
	if Global.ink.total_volume() >= ink_cost*20:
		var ink_inst = load("res://Scenes/splash.tscn").instantiate()
		ink_inst.global_position = global_position
		Global.root.get_node("Splashes").add_child(ink_inst)
		ink_inst.get_node("Emitter").emitting = true
		if Global.ink.queue[0].is_ink:
			ink_inst.get_node("Emitter").color = Color(0, 0, 0)
		else:
			ink_inst.get_node("Emitter").color = Color(1, 0, 0)
		Global.ink.retrieve(ink_cost*20)
		$SFX/InkSplash.play()
		
func bounce(collision: KinematicCollision2D):
	var norm: Vector2 = collision.get_normal()
	var lengthA: float = max(200, target_velocity.length())
	var lengthB: float = max(200, collision.get_collider_velocity().length())
	var length: float = min(20, sqrt(lengthA * lengthB))
	var dir: Vector2 = target_velocity.bounce(norm).normalized()
	target_velocity = dir * length
	$SFX/Bounce.play()

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
		var collision: KinematicCollision2D = move_and_collide(vec)
		if collision != null and not collision.get_collider().is_in_group("enemies") and not collision.get_collider().is_in_group("projectile"):
			bounce(collision)
	if frozen == true:
		frozen_timer -= delta
	if frozen_timer <= 0.0:
		frozen = false
	if Global.ink.total_volume() <= 0.0:
		die()
	
	$Camera2D.offset = (get_global_mouse_position() - global_position) * 0.15
		

func touch_coffee():
	Global.ink.retrieve(100)
	frozen = true
	frozen_timer = 3.0
	$SFX/Stunned.play()

	
	


#signal from MapManager
func _on_map_manager_update_cam_bounds(x, y):
	if x != null:
		$Camera2D.limit_right = x
	if y != null:
		$Camera2D.limit_bottom = y

func _on_area_2d_area_entered(area):
	if area.is_in_group("projectile"):
		Global.ink.retrieve(50)
		if Global.rng.randi_range(0, 1):
			$SFX/Damaged1.play()
		else:
			$SFX/Damaged2.play()

func die():
	if dead == false:
		print("lmfao")
		$SFX/Death.play()
		dead = true
