extends Node2D

var rng = RandomNumberGenerator.new()
var timer = rng.randf_range(6.0, 10.0)
var volume: float = 0.0

func _process(delta):
	scale = Vector2(volume / 100.0, volume / 100.0)

func _physics_process(delta):
	timer -= delta
	if timer <= 0.0:
		queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("printer"):
		Global.ink.add(false, volume)
		queue_free()
