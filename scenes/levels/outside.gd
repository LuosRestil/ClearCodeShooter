extends Level

const INSIDE = preload("res://scenes/levels/inside.tscn")
const INSIDE_PATH = "res://scenes/levels/inside.tscn"

func _on_gate_entered(_body: Node2D) -> void:
	var tween = create_tween()
	tween.tween_property(player, "speed", 0, 0.5)
	LevelTransition.load_level(INSIDE_PATH)

func _on_house_player_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(camera_2d, "zoom", Vector2(0.9, 0.9), 1)

func _on_house_player_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(camera_2d, "zoom", Vector2(0.7, 0.7), 1)
