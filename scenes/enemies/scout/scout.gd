extends CharacterBody2D

signal laser(pos: Vector2, dir: Vector2)

@onready var spawners: Array[Marker2D] = [$LaserSpawnPt1, $LaserSpawnPt2]
@onready var particles: Array[GPUParticles2D] = [$LaserParticles1, $LaserParticles2]
@onready var laser_cooldown: Timer = $LaserCooldown
@onready var damage_cooldown: Timer = $DamageCooldown
@onready var sprite: Sprite2D = $Sprite2D

var health := 30
var player_detected := false
var can_laser := true
var damageable := true
var cannon_num := 0

func _process(_delta: float) -> void:
	if not player_detected:
		return
	look_at(Globals.player_position)
	if (can_laser):
		laser.emit(spawners[cannon_num].global_position, rotation)
		particles[cannon_num].emitting = true
		laser_cooldown.start()
		can_laser = false
		cannon_num = (cannon_num + 1) % 2
		
func take_hit() -> void:
	if not damageable: return
	damageable = false
	damage_cooldown.start()
	sprite.material.set_shader_parameter("amount", 1)
	health -= 10
	if health <= 0:
		queue_free()

func _on_player_detect_zone_body_entered(_body: Node2D) -> void:
	player_detected = true

func _on_player_detect_zone_body_exited(_body: Node2D) -> void:
	player_detected = false

func _on_laser_cooldown_timeout() -> void:
	can_laser = true

func _on_damage_cooldown_timeout() -> void:
	damageable = true
	sprite.material.set_shader_parameter("amount", 0)
