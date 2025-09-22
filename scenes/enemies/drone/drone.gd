extends Node2D

@export var speed: float = 200

func _process(delta: float) -> void:
	position.x += speed * delta
	if position.x > 2000:
		position.x = -500
		position.y = randf_range(100, 1000)

func take_hit() -> void:
	pass
