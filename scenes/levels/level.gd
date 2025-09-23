class_name Level extends Node2D

const LASER = preload("res://scenes/projectiles/laser.tscn")
const GRENADE = preload("res://scenes/projectiles/grenade.tscn")
const ITEM = preload("res://scenes/items/item.tscn")

@onready var player: CharacterBody2D = $Player
@onready var camera_2d: Camera2D = $Player/Camera2D
@onready var projectile_container: Node2D = $Projectiles
@onready var ui: UI = $UI
@onready var items: Node2D = $Items

func _ready():
	var item_containers := get_tree().get_nodes_in_group("ItemContainer")
	for item_container in item_containers:
		item_container.connect("open", _on_container_open)
	var scouts := get_tree().get_nodes_in_group("Scouts")
	for scout in scouts:
		scout.connect("laser", _on_scout_laser)

func _on_player_laser(pos: Vector2, angle: float) -> void:
	_spawn_laser(pos, angle)
	Globals.laser_count -= 1

func _on_player_grenade(pos: Vector2, angle: float) -> void:
	var grenade = GRENADE.instantiate() as RigidBody2D
	var dir = Vector2.RIGHT.rotated(angle) * grenade.speed
	grenade.position = pos
	grenade.linear_velocity = dir
	projectile_container.add_child(grenade)
	Globals.grenade_count -= 1
	
func _on_scout_laser(pos: Vector2, angle: float) -> void:
	_spawn_laser(pos, angle)
	
func _spawn_laser(pos: Vector2, angle: float):
	var laser = LASER.instantiate()
	laser.position = pos
	laser.rotation = angle
	laser.dir = Vector2.RIGHT.rotated(angle)
	projectile_container.add_child(laser)

func _on_container_open(pos: Vector2, dir: Vector2):
	var item = ITEM.instantiate()
	item.global_position = pos
	items.call_deferred("add_child", item)
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		item, 
		"position", 
		item.position + dir * randi_range(150, 250), 
		0.5
	)
	
