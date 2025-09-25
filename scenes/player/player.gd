class_name Player extends CharacterBody2D

signal laser(pos: Vector2, angle: float)
signal grenade(pos: Vector2, angle: float)

@onready var laser_timer: Timer = $LaserTimer
@onready var grenade_timer: Timer = $GrenadeTimer
@onready var gun_tip: Marker2D = $GunTip
@onready var laser_particles: GPUParticles2D = $LaserParticles
@onready var damage_cooldown: Timer = $DamageCooldown
@onready var sprite: Sprite2D = $PlayerImg

@export var max_speed: float = 500;
var speed: float
var can_laser: bool = true
var can_grenade: bool = true
var damageable: bool = true

func _ready() -> void:
	speed = max_speed
	
func _process(_delta: float) -> void:
	var dir = Input.get_vector("left", "right", "up", "down")
	velocity = speed * dir
	look_at(get_global_mouse_position())
	move_and_slide()
	Globals.player_position = global_position
	
	if (
		Input.is_action_just_pressed("primary_action") and 
		can_laser and 
		Globals.laser_count > 0
	):
		can_laser = false
		laser_timer.start()
		laser.emit(gun_tip.global_position, rotation)
		laser_particles.emitting = true;
		
	if (
		Input.is_action_just_pressed("secondary_action") and 
		can_grenade and 
		Globals.grenade_count > 0
	):
		grenade_timer.start()
		can_grenade = false
		grenade.emit(gun_tip.global_position, rotation)

func _on_laser_timer_timeout() -> void:
	can_laser = true

func _on_grenade_timer_timeout() -> void:
	can_grenade = true
	
func take_hit():
	if not damageable: return
	damageable = false
	Globals.player_health -= 10
	sprite.material.set_shader_parameter("amount", 1)
	damage_cooldown.start()

func _on_damage_cooldown_timeout() -> void:
	damageable = true
	sprite.material.set_shader_parameter("amount", 0)
