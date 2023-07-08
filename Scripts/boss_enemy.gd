extends CharacterBody2D


var health: float = 200.0
var regen: float = 20.0
var shield: float = 200.0
const speed: float = 50
var target_velocity: Vector2

func _ready():
	pass

var timer: float = 0

func damage(delta: float):
	var shield_delta: float = min(delta, shield)
	shield -= shield_delta
	delta -= shield_delta
	health -= delta
	
func _process(delta):
	health += regen * delta	
	shield += max(0, health - 200.0)
	health = min(health, 200.0)
	$HealthBar.value = health
	$ShieldBar.value = shield

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
		if not collision.get_collider().is_in_group("enemies"):
			bounce(collision)

func _on_area_2d_body_entered(body):
	if body.is_in_group("printer"):
		var dmg: float = min(80, health + shield)
		# TODO play death/attack animation
		Global.ink.retrieve(dmg / 5.0)
		damage(dmg)
		if health <= 0:
			die()

func _on_area_2d_area_entered(area):
	if area.is_in_group("paper"):
		damage(40.0)
		if health <= 0.0:
			die()

func die():
	# TODO play death animation
	var blood_inst = load("res://Scenes/blood.tscn").instantiate()
	blood_inst.position = global_position
	blood_inst.volume = 100.0
	get_tree().root.call_deferred("add_child", blood_inst)
	queue_free()
