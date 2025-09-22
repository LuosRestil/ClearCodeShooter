class_name ItemContainer extends StaticBody2D

signal open(pos: Vector2, dir: Vector2)

@onready var lid: Sprite2D = $Lid
@onready var dir = Vector2.DOWN.rotated(rotation)
@onready var spawn_points: Node2D = $SpawnPoints

var is_open := false

func take_hit() -> void:
	if is_open: return
	lid.hide()
	open.emit(get_random_spawn_point(), dir)
	is_open = true
	
	
func get_random_spawn_point() -> Vector2:
	var spawn_point = spawn_points.get_children()[randi()%spawn_points.get_child_count()]
	return spawn_point.global_position
