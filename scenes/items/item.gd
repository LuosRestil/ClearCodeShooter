extends Area2D

@export var rot_speed: float = TAU

@onready var sprite: Sprite2D = $Sprite2D

enum Type { LASER, GRENADE, HEALTH }
var type_options := [Type.LASER, Type.LASER, Type.LASER, Type.GRENADE, Type.HEALTH]
var type: Type

func _ready():
	type = type_options[randi_range(0, type_options.size() - 1)]
	set_color()

func _process(delta: float) -> void:
	rotate(rot_speed * delta)

func set_color():
	match type:
		Type.LASER:
			sprite.modulate = Color.DEEP_SKY_BLUE
		Type.GRENADE:
			sprite.modulate = Color.RED
		Type.HEALTH:
			sprite.modulate = Color.LIME_GREEN
		_:
			print("invalid type")
			
func _on_body_entered(_body: Node2D) -> void:
	match type:
		Type.LASER:
			Globals.laser_count += 5
		Type.GRENADE:
			Globals.grenade_count += 1
		Type.HEALTH:
			Globals.player_health += 10
		_:
			print("invalid type")
	queue_free()
