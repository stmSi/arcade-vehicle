extends Node3D


@onready var ball : RigidBody3D = $Ball
@onready var car_mesh : Node3D = $CarMesh
@onready var ground_ray : RayCast3D = $CarMesh/RayCast3D
@onready var camera_3d = $Camera3D

# Where to place the car mesh relative to the sphere
var sphere_offset = Vector3(0, -1.0, 0)

# Camera Stuff
var camera_distance = Vector3(0, 4, 10) # The distance of the camera from the car mesh
var camera_damping = 0.1 # Controls the springiness of the camera

# Engine power
var acceleration = 50
var deacceleration = -50
# Brake
var brake = 50

# Turn amount, in degrees
var steering = 21.0

# How quickly the car turns
var turn_speed = 5

# Below this speed, the car doesn't turn
var turn_stop_limit = 0.75

# variables for input values
var speed_input = 0
var rotate_input = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	# Keep car mesh aligned with the sphere
	car_mesh.transform.origin = ball.transform.origin + sphere_offset
	
	# accelerate based on car's forward direction
	ball.apply_central_force(-car_mesh.global_transform.basis.z * speed_input)


	# align with ground
	var n = ground_ray.get_collision_normal()
	var xform = align_with_y(car_mesh.global_transform, n.normalized())
	car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform, 1 * delta)
	

	# Code to update the camera's position like a spring
	var target_position = car_mesh.global_transform.origin + \
		car_mesh.global_transform.basis.z * camera_distance.z + \
		car_mesh.global_transform.basis.y * camera_distance.y
	camera_3d.global_transform.origin = camera_3d.global_transform.origin.lerp(target_position, camera_damping)
	
	camera_3d.look_at(car_mesh.global_transform.origin, Vector3.UP)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	# Get steering input
	rotate_input = 0
	rotate_input += Input.get_action_strength("steer_left")
	rotate_input -= Input.get_action_strength("steer_right")
	rotate_input *= deg_to_rad(steering)

	# rotate car mesh
	if rotate_input and ball.linear_velocity.length() > turn_stop_limit:
		var new_transform = car_mesh.global_transform.rotated(
				car_mesh.global_transform.basis.y, 
				rotate_input
			)


		car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_transform.basis, turn_speed * delta)
		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()


	# can't accelerate when in air
	if not ground_ray.is_colliding():
		return
	
	# Get accelerate/brake input
	speed_input = 0
	speed_input += Input.get_action_strength("accelerate")
	speed_input -= Input.get_action_strength("back")
	speed_input *= acceleration

	if Input.is_action_pressed("break") and ball.linear_velocity.length() > 1:
		speed_input = deacceleration * -ball.linear_velocity.normalized()
		if ball.linear_velocity.length() < 1:
			speed_input = 0
		print(ball.linear_velocity)
		
#	if rotate_input != 0:
#		print('rotate_input ', rotate_input)
	pass

func align_with_y(xform: Transform3D, new_y: Vector3):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
