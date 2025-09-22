extends Level

const OUTSIDE: PackedScene = preload("res://scenes/levels/outside.tscn")
const OUTSIDE_PATH = "res://scenes/levels/outside.tscn"

func _on_area_2d_body_entered(_body: Node2D) -> void:
	var tween = create_tween()
	tween.tween_property(player, "speed", 0, 0.5)
	LevelTransition.load_level(OUTSIDE_PATH)
