extends CharacterBody2D


var rng = RandomNumberGenerator.new()
const speed: float = 50
var target_velocity: Vector2
var active : bool = false

func _ready():
	pass

var timer: float = 0

func activate():
	active = true

func bounce(collision: KinematicCollision2D):
	var norm: Vector2 = collision.get_normal()
	var lengthA: float = max(20, target_velocity.length())
	var lengthB: float = max(20, collision.get_collider_velocity().length())
	var length: float = min(speed/2, sqrt(lengthA * lengthB))
	var dir: Vector2 = target_velocity.bounce(norm).normalized()
	target_velocity = dir * length

var coffee_timer: float = rng.randf_range(3.0, 7.0)

func _physics_process(delta):
	if active && Global.map != null:
		coffee_timer -= delta
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
		if coffee_timer <= 0:
			coffee_timer = rng.randf_range(3.0, 7.0)
			shoot_coffee()
			var normal_enemy_inst = load("res://Enemies/normal_enemy.tscn").instantiate()
			normal_enemy_inst.position = position
			normal_enemy_inst.add_to_group("normal")
			get_parent().add_child(normal_enemy_inst)
			normal_enemy_inst.activate()
			queue_free()
		
		

func shoot_coffee():
	var coffee_inst = load("res://Scenes/coffee.tscn").instantiate()
	Global.root.get_node("Splashes").add_child(coffee_inst)
	coffee_inst.global_position = global_position
	
func die():
	Global.score += 20

