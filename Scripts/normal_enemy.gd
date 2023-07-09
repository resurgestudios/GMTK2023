extends CharacterBody2D


var proj_speed: float = 500.0
var shoot_range: float = 400.0
var health: float = 100.0
var regen: float = 2.0
var shield: float = 0.0
const speed: float = 200
var direction: float = Global.rng.randf_range(0, 2 * PI)
var target_velocity: Vector2
var updated: bool = false
var following: Node2D = null
var active : bool = false

func activate():
	active = true

func bounce(collision: KinematicCollision2D):
	var norm: Vector2 = collision.get_normal()
	var lengthA: float = max(200, target_velocity.length())
	var lengthB: float = max(200, collision.get_collider_velocity().length())
	var length: float = sqrt(lengthA * lengthB)
	if not collision.get_collider().is_in_group("printer"):
		length = min(length, speed)
	var dir: Vector2 = target_velocity.bounce(norm).normalized()
	target_velocity = dir * length

func _ready():
	$Normal.show()
	$Angry.hide()

var timer: float = 0

func damage(delta: float):
	var shield_delta: float = min(delta, shield)
	shield -= shield_delta
	delta -= shield_delta
	health -= delta

func _process(delta):
	if following == null:
		$Normal.show()
		$Angry.hide()
		shield = 0.0
	health += regen * delta	
	health = min(health, 100.0)
	$HealthBar.value = health
	$ShieldBar.value = shield

func _physics_process(delta):
	if not active:
		return
	velocity = target_velocity
	timer -= delta
	if timer <= 0:
		if following != null:
			var cur: Vector2i = Global.closest_point(global_position)
			var end: Vector2i = Global.closest_point(following.global_position)
			var path: PackedVector2Array = Global.map.get_point_path(cur, end)
			if len(path) > 1:
				var next: Vector2 = path[1]
				target_velocity = (next - global_position).normalized() * speed
		else:
			direction += Global.rng.randf_range(-1.0, 1.0)
			target_velocity = speed * Vector2(cos(direction), sin(direction))
		timer = Global.rng.randf_range(0.75, 1.25)
		var player_pos: Vector2 = get_node("/root/Main/Printer").global_position
		if following != null or ((global_position - player_pos).length() <= shoot_range and Global.rng.randi_range(0, 2) == 0):
			var proj_inst = load("res://Scenes/projectile.tscn").instantiate()
			get_tree().root.add_child(proj_inst)
			var angle = global_position.angle_to_point(player_pos)
			proj_inst.velocity.y = proj_speed * sin(angle)
			proj_inst.velocity.x = proj_speed * cos(angle)
			if following != null:
				proj_inst.velocity *= 1.25
			proj_inst.position = global_position
			
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision != null:
		bounce(collision)

func follow():
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("printer"):
		var dmg: float = min(80, health + shield)
		# TODO play death/attack animation
		Global.ink.retrieve(dmg / 5.0)
		damage(dmg)
		if health <= 0:
			die()

func _on_area_2d_area_entered(area):
	if area.is_in_group("boss") and following == null:
		$Normal.hide()
		$Angry.show()
		following = area.get_parent()
		shield += 50.0
		following.damage(50.0)
	if area.is_in_group("paper"):
		damage(40.0)
		if health <= 0.0:
			die()
	if area.is_in_group("ink"):
		die()

func die():
	# TODO play death animation
	Global.score += 20
	var blood_inst = load("res://Scenes/blood.tscn").instantiate()
	blood_inst.position = global_position
	blood_inst.volume = 50.0
	Global.root.get_node("Splashes").call_deferred("add_child", blood_inst)
	queue_free()
