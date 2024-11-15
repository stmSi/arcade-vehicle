extends AnimatableBody3D
@export var bullet_speed = 200.0
const SPLASH_EFFECT = preload("res://src/SplashEffect/splash_effect.tscn")

func _physics_process(delta):
	var forward = -transform.basis.z.normalized()
	var movement = forward * bullet_speed * delta
	var collision = move_and_collide(movement)
	if collision:
		_on_bullet_collided(collision)

func _ready():
	pass

func _on_bullet_life_time_timeout():
	queue_free()

func _on_bullet_collided(collision: KinematicCollision3D):
	var collision_point = collision.get_position()
	spawn_splash_effect(collision_point)
	#play_hit_sound(collision_point)
	#var collider = collision.collider
	#if collider.is_in_group("Enemies"):
		#collider.take_damage(damage_amount)
	queue_free()

func spawn_splash_effect(position):
	var splash_instance = SPLASH_EFFECT.instantiate()
	splash_instance.global_transform.origin = position
	get_tree().current_scene.add_child(splash_instance)
	splash_instance.emitting = true
