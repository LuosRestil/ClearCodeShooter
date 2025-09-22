extends Area2D

@export var speed: float = 400
var dir: Vector2

func _process(delta: float) -> void:
	position += speed * delta * dir

func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if "take_hit" in body:
		body.take_hit()
	queue_free()
