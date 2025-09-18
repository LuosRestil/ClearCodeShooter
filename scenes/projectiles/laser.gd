extends Area2D

@export var speed: float = 400
var dir: Vector2

func _process(delta: float) -> void:
	position += speed * delta * dir
