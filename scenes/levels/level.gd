extends Node2D

const LASER = preload("res://scenes/projectiles/laser.tscn")
const GRENADE = preload("res://scenes/projectiles/grenade.tscn")

@onready var player: CharacterBody2D = $Player
@onready var camera_2d: Camera2D = $Player/Camera2D
@onready var projectile_container: Node2D = $Projectiles

func _on_gate_entered(_body: Node2D) -> void:
	var tween = create_tween()
	tween.tween_property(player, "speed", 0, 0.5)

func _on_player_laser(pos: Vector2, angle: float) -> void:
	var laser = LASER.instantiate()
	laser.position = pos
	laser.rotation = angle
	laser.dir = Vector2.RIGHT.rotated(angle)
	projectile_container.add_child(laser)

func _on_player_grenade(pos: Vector2, angle: float) -> void:
	var grenade = GRENADE.instantiate() as RigidBody2D
	var dir = Vector2.RIGHT.rotated(angle) * grenade.speed
	grenade.position = pos
	grenade.linear_velocity = dir
	projectile_container.add_child(grenade)

func _on_house_player_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(camera_2d, "zoom", Vector2(0.9, 0.9), 1)


func _on_house_player_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(camera_2d, "zoom", Vector2(0.7, 0.7), 1)
