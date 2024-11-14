extends Node3D
@export var bullet_speed = 150.0

# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Move the bullet along the negative Z-axis based on the speed and delta time
	var movement = Vector3(0, 0, -bullet_speed * delta)
	translate(movement)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_bullet_life_time_timeout():
	queue_free()
	pass # Replace with function body.
