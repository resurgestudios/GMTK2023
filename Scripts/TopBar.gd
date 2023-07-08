extends CharacterBody2D

func _ready():
	$AnimatedSprite2D.play("default")

func _physics_process(delta):
	position.y = 1080 - Global.ink * 1080 + 100
	
