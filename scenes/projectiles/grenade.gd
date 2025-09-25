extends RigidBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var speed = 2000
@export var blast_radius = 600

var exploding := false

func explode():
	freeze = true
	animation_player.play("explode")
	exploding = true

func _process(_delta: float):
	if not exploding: return
	var targets := get_tree().get_nodes_in_group("ItemContainer") + get_tree().get_nodes_in_group("Entity")
	for target in targets:
		var dist = target.global_position.distance_to(global_position)
		if dist <= blast_radius and "take_hit" in target: target.take_hit()
