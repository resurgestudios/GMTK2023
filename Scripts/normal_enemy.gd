extends CharacterBody2D


var health: float = 100.0
var regen: float = 2.0
var shield: float = 0.0
const speed: float = 200
var direction: float = Global.rng.randf_range(0, 2 * PI)
var target_velocity: Vector2
var updated: bool = false
var following: Node2D = null

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
	velocity = target_velocity
	timer -= delta
	if timer <= 0:
		if following != null:
			var cur: Vector2i = Global.closest_point(position)
			var end: Vector2i = Global.closest_point(following.position)
			var path: PackedVector2Array = Global.map.get_point_path(cur, end)
			if len(path) > 1:
				var next: Vector2 = path[1]
				target_velocity = (next - position).normalized() * speed
		else:
			direction += Global.rng.randf_range(-1.0, 1.0)
			target_velocity = speed * Vector2(cos(direction), sin(direction))
		timer = Global.rng.randf_range(0.75, 1.25)
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision != null:
		bounce(collision)

func follow():
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("boss") and following == null:
		$Normal.hide()
		$Angry.show()
		following = body
		shield += 50.0
		body.damage(50.0)
	if body.is_in_group("printer"):
		var dmg: float = min(80, health + shield)
		# TODO play death/attack animation
		Global.ink.retrieve(dmg / 5.0)
		damage(dmg)
		if health <= 0:
			queue_free()

func _on_area_2d_area_entered(area):
	if area.is_in_group("paper"):
		damage(40.0)
		if health <= 0.0:
			die()

func die():
	# TODO play death animation
	pass



