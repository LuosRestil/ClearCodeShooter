extends Node2D

const LASER = preload("res://scenes/projectiles/laser.tscn")
const GRENADE = preload("res://scenes/projectiles/grenade.tscn")

@onready var projectile_container: Node2D = $Projectiles

func _on_gate_entered(body: Node2D) -> void:
	pass

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
