extends CharacterBody2D

@onready var damage_cooldown: Timer = $DamageCooldown
@onready var sprite: Sprite2D = $DroneImg
@onready var animation: AnimationPlayer = $AnimationPlayer

@export var base_speed := 200.0
@export var accel := 100

var speed: float
# TODO use raycast for player detection
# so we don't try to attack through walls
var player_in_range := false
var health := 20
var damageable := true
var blast_radius := 600

func _ready() -> void:
	speed = base_speed

func _process(delta: float) -> void:
	if animation.is_playing():
		damage_entities()
		return
		
	if player_in_range:
		look_at(Globals.player_position)
		speed += accel * delta
		velocity = speed * (Globals.player_position - global_position).normalized()
		var collided := move_and_slide()
		if collided:
			explode()
			
func explode():
	animation.play("explosion")
		
func take_hit() -> void:
	if not damageable: return
	damageable = false
	damage_cooldown.start()
	sprite.material.set_shader_parameter("amount", 1)
	health -= 10
	if health <= 0:
		explode()
		
func damage_entities():
	var targets := get_tree().get_nodes_in_group("ItemContainer") + get_tree().get_nodes_in_group("Entity")
	for target in targets:
		var dist = target.global_position.distance_to(global_position)
		if dist <= blast_radius and "take_hit" in target: target.take_hit()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	player_in_range = true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	player_in_range = false
	speed = base_speed


func _on_damage_cooldown_timeout() -> void:
	damageable = true
	sprite.material.set_shader_parameter("amount", 0)
