extends CharacterBody2D

signal laser(pos: Vector2, angle: float)
signal grenade(pos: Vector2, angle: float)

@onready var laser_timer: Timer = $LaserTimer
@onready var grenade_timer: Timer = $GrenadeTimer
@onready var gun_tip: Marker2D = $GunTip
@onready var laser_particles: GPUParticles2D = $LaserParticles

@export var max_speed = 500;
var speed = max_speed
var can_laser: bool = true
var can_grenade: bool = true

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	var dir = Input.get_vector("left", "right", "up", "down")
	velocity = speed * dir
	look_at(get_global_mouse_position())
	move_and_slide()
	
	if Input.is_action_just_pressed("primary_action") and can_laser:
		can_laser = false
		laser_timer.start()
		laser.emit(gun_tip.global_position, rotation)
		laser_particles.emitting = true;
		
	if Input.is_action_just_pressed("secondary_action") and can_grenade:
		grenade_timer.start()
		can_grenade = false
		grenade.emit(gun_tip.global_position, rotation)


func _on_laser_timer_timeout() -> void:
	can_laser = true


func _on_grenade_timer_timeout() -> void:
	can_grenade = true
