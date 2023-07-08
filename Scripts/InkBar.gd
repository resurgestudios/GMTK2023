extends Node2D

var queue = [
	{"is_ink": true, "volume": 200.0},
	{"is_ink": false, "volume": 100.0},
	{"is_ink": true, "volume": 50.0},
	{"is_ink": false, "volume": 75.0}
]

var total_volume: int = 425
var capacity: int = 1000

# return the actual amount of ink put in the tank
func add(is_ink: bool, delta_volume: float) -> float:
	var N: int = len(queue)
	delta_volume = min(delta_volume, capacity - total_volume)
	if N > 0 and queue[N-1].is_ink == is_ink:
		queue[N-1].volume += delta_volume
	else:
		queue.push_back({"is_ink": is_ink, "volume": delta_volume})
	total_volume += delta_volume
	return delta_volume

# returns the actual amount of ink retrieved from the tank
func retrieve(delta_volume: float) -> float:
	delta_volume = min(delta_volume, total_volume)
	if delta_volume > 0:
		var delta_delta_volume: float = min(delta_volume, queue[0].volume)
		delta_volume -= delta_delta_volume
		queue[0].volume -= delta_delta_volume
		total_volume -= delta_delta_volume
		if is_equal_approx(queue[0].volume, 0.0):
			queue.pop_front()
		return delta_delta_volume + retrieve(delta_volume)
	else:
		return 0

func redraw():
	var flow = null
	for child in get_children():
		if not child.is_in_group("flow"):
			child.queue_free()
		else:
			flow = child
	var offsetY: float = 0
	for i in range(len(queue)):
		var inst: Node2D = null
		if queue[i].is_ink:
			inst = load("res://Scenes/black_bar.tscn").instantiate()
		else:
			inst = load("res://Scenes/red_bar.tscn").instantiate()
		inst.position.y -= offsetY
		inst.apply_scale(Vector2(1, float(queue[i].volume) / 100.0))
		offsetY += queue[i].volume
		self.add_child(inst)
	flow.position.y = -offsetY - 7
	flow.play("default")
	
	if total_volume <= 0.0:
		flow.queue_free()
	else:
		if queue.back().is_ink:
			flow.modulate = Color(0, 0, 0)
		else:
			flow.modulate = Color(1, 1, 1)
		
func _ready():
	Global.ink = self
	redraw()

var timer: float = 2.0

