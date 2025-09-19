extends RigidBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var speed = 2000

func explode():
	animation_player.play("explode")
