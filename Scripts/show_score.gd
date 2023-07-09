extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Game Over! You scored " + str(Global.score) + " points!"
