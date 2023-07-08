extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("w"):
		position.y -= 30
	elif Input.is_action_pressed("s"):
		position.y += 30
	if Input.is_action_pressed("a"):
		position.x -= 30
	elif Input.is_action_pressed("d"):
		position.x += 30
