extends StaticBody2D

signal entered(body: Node2D)

func _on_entrance_trigger_body_entered(body: Node2D) -> void:
	entered.emit(body)
