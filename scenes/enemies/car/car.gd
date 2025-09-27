extends PathFollow2D

@onready var damage_cooldown: Timer = $DamageCooldown
@onready var sprite: Sprite2D = $CarSprite
@onready var turret: Node2D = $Turret
@onready var ray_cast_1: RayCast2D = $Turret/RayCast2D
@onready var ray_cast_2: RayCast2D = $Turret/RayCast2D2
@onready var line_1: Line2D = $Turret/RayCast2D/Line2D
@onready var line_2: Line2D = $Turret/RayCast2D2/Line2D2
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gunfire: Sprite2D = $Turret/Gunfire
@onready var gunfire_2: Sprite2D = $Turret/Gunfire2

@export var speed: float = 0.015

var damageable := true
var health: float = 50
var player_in_range := false

func _ready() -> void:
	line_1.add_point(ray_cast_1.target_position)
	line_2.add_point(ray_cast_2.target_position)

func _process(delta: float) -> void:
	progress_ratio += speed * delta
	if not player_in_range: return
	turret.look_at(Globals.player_position)
	if ray_cast_1.is_colliding():
		var dist = ray_cast_1.global_position.distance_to(ray_cast_1.get_collision_point())
		line_1.points[1] = Vector2(dist, 0)
	if ray_cast_2.is_colliding():
		var dist = ray_cast_2.global_position.distance_to(ray_cast_2.get_collision_point())
		line_2.points[1] = Vector2(dist, 0)

func take_hit():
	if not damageable: return
	damageable = false
	damage_cooldown.start()
	sprite.material.set_shader_parameter("amount", 1)
	health -= 10
	if health <= 0:
		queue_free()
		
func fire():
	Globals.player.take_hit()
	gunfire.modulate = Color.WHITE
	gunfire_2.modulate = Color.WHITE
	var tween = create_tween().set_parallel(true)
	tween.tween_property(gunfire, "modulate", Color.TRANSPARENT, 0.3)
	tween.tween_property(gunfire_2, "modulate", Color.TRANSPARENT, 0.3)
	

func _on_damage_cooldown_timeout() -> void:
	damageable = true
	sprite.material.set_shader_parameter("amount", 0)

func _on_notice_area_body_entered(_body: Node2D) -> void:
	player_in_range = true
	animation_player.play("laser_load")

func _on_notice_area_body_exited(_body: Node2D) -> void:
	player_in_range = false
	animation_player.pause()
	var tween = create_tween().set_parallel(true)
	tween.tween_property(line_1, "width", 0, 0.3)
	tween.tween_property(line_2, "width", 0, 0.3)
	await tween.finished
	animation_player.stop()


func _on_character_body_2d_took_hit() -> void:
	take_hit()
