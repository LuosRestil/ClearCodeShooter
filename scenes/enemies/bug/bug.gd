extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var damage_cooldown: Timer = $DamageCooldown
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var hit_particles: GPUParticles2D = $HitParticles

@export var health := 40
@export var jump_dist := 100
@export var speed: float = 400
var player_in_range := false
var attacking := false
var damageable := true
var active = true

func _process(_delta: float) -> void:
	if not player_in_range: return
	
	look_at(Globals.player_position)
	
	if not active: return
	
	var to_player := (Globals.player_position - global_position).normalized()

	if attacking:
		if sprite.frame == 7: # start of bite portion of animation
			var jump := to_player * jump_dist
			var tween = create_tween()
			tween.tween_property(self, "global_position", global_position + jump, 0.2)
			var collision := move_and_collide(to_player * 100)
			if collision and collision.get_collider() is Player:
				collision.get_collider().take_hit()
				active = false
				attack_cooldown.start()
		return

#	# in range, not attacking, chase
	velocity = to_player * speed
	move_and_slide()

func _on_notice_area_body_entered(_body: Node2D) -> void:
	sprite.play("walk")
	player_in_range = true

func _on_notice_area_body_exited(_body: Node2D) -> void:
	sprite.play("default")
	player_in_range = false

func _on_attack_area_body_entered(_body: Node2D) -> void:
	sprite.play("attack")
	attacking = true

func _on_attack_area_body_exited(_body: Node2D) -> void:
	sprite.play("walk")
	attacking = false
	
func _on_damage_cooldown_timeout() -> void:
	damageable = true
	sprite.material.set_shader_parameter("amount", 0)
	
func _on_attack_cooldown_timeout() -> void:
	active = true
	if attacking: sprite.play("attack")
	elif player_in_range: sprite.play("walk")

func take_hit():
	if not damageable: return
	damageable = false
	damage_cooldown.start()
	sprite.material.set_shader_parameter("amount", 1)
	hit_particles.emitting = true
	health -= 10
	if health <= 0:
		queue_free()
