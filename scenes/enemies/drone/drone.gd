extends CharacterBody2D

@onready var damage_cooldown: Timer = $DamageCooldown
@onready var sprite: Sprite2D = $DroneImg

@export var base_speed := 200.0
@export var accel := 100

var speed: float
var player_in_range := false
var health := 20
var damageable := true

func _ready() -> void:
	speed = base_speed

func _process(delta: float) -> void:
	if player_in_range:
		look_at(Globals.player_position)
		speed += accel * delta
		velocity = speed * (Globals.player_position - global_position).normalized()
		var collided := move_and_slide()
		if collided:
			explode()
			
func explode():
	queue_free()
		
func take_hit() -> void:
	if not damageable: return
	damageable = false
	damage_cooldown.start()
	sprite.material.set_shader_parameter("amount", 1)
	health -= 10
	if health <= 0:
		queue_free()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	player_in_range = true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	player_in_range = false
	speed = base_speed


func _on_damage_cooldown_timeout() -> void:
	damageable = true
	sprite.material.set_shader_parameter("amount", 0)
