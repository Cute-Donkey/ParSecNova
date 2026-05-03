extends Node3D

var camera: Camera3D
var cube: MeshInstance3D
var player: Node3D
var rotation_speed: float = 2.0
var thrust_speed: float = 10.0
var camera_distance: float = 8.0
var camera_height: float = 3.0

func _ready():
	camera = $Camera3D
	cube = $TestCube
	
	# Create player node (spaceship)
	player = Node3D.new()
	player.name = "Player"
	add_child(player)
	
	# Initialize positions
	player.position = Vector3(0, 0, 0)
	cube.position = Vector3(10, 0, 0)  # Cube in front of player
	update_camera_position()
	print("TestControls initialized!")

func _process(delta):
	var player_moved = false
	
	# Player rotation (arrow keys rotate the player)
	if Input.is_action_pressed("ui_left"):
		player.rotate_y(rotation_speed * delta)
		player_moved = true
	if Input.is_action_pressed("ui_right"):
		player.rotate_y(-rotation_speed * delta)
		player_moved = true
	if Input.is_action_pressed("ui_up"):
		player.rotate_x(rotation_speed * delta)
		player_moved = true
	if Input.is_action_pressed("ui_down"):
		player.rotate_x(-rotation_speed * delta)
		player_moved = true
	
	# Thrust (spacebar moves player forward)
	if Input.is_action_pressed("ui_accept"):  # Spacebar
		var forward = -player.global_transform.basis.z
		player.position += forward * thrust_speed * delta
		player_moved = true
	
	if player_moved:
		update_camera_position()

func update_camera_position():
	# Camera follows player with offset
	camera.position = player.position + Vector3(0, camera_height, camera_distance)
	camera.look_at(player.position)
