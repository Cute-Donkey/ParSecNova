extends Node3D

var camera: Camera3D
var cube: MeshInstance3D
var rotation_speed: float = 1.0
var zoom_speed: float = 5.0
var camera_distance: float = 8.0
var camera_angle: float = 0.0
var camera_height: float = 3.0

func _ready():
	camera = $Camera3D
	cube = $TestCube
	# Initialize camera position
	update_camera_position()
	print("TestControls initialized!")

func _process(delta):
	var camera_moved = false
	
	# Camera rotation around cube (orbit camera)
	if Input.is_action_pressed("ui_left"):
		camera_angle -= rotation_speed * delta
		camera_moved = true
	if Input.is_action_pressed("ui_right"):
		camera_angle += rotation_speed * delta
		camera_moved = true
	
	# Zoom in/out
	if Input.is_action_pressed("ui_up"):
		camera_distance = max(3.0, camera_distance - zoom_speed * delta)
		camera_moved = true
	if Input.is_action_pressed("ui_down"):
		camera_distance = min(20.0, camera_distance + zoom_speed * delta)
		camera_moved = true
	
	if camera_moved:
		update_camera_position()

func update_camera_position():
	# Calculate camera position in orbit around cube
	camera.position.x = cos(camera_angle) * camera_distance
	camera.position.z = sin(camera_angle) * camera_distance
	camera.position.y = camera_height
	
	# Always look at the cube
	camera.look_at(cube.global_position)
