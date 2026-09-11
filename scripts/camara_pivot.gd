extends Node3D

@export var target_ball: RigidBody3D # Arrastra tu nodo Ball aquí en el Inspector luego de guardar
@onready var spring_arm = $SpringArm3D

var rotation_speed = 2.5
var zoom_speed = 0.2
var min_zoom = 0.2
var max_zoom = 1.5

func _process(delta):
	if target_ball:
		# El pivote sigue la posición de la bola constantemente
		global_position = target_ball.global_position

	# Rotación Horizontal (A/D o Flechas Izq/Der)
	var rot_y = 0.0
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT): rot_y += 1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT): rot_y -= 1
	
	rotation.y += rot_y * rotation_speed * delta
	
	# Rotación Vertical (W/S o Flechas Arr/Aba)
	var rot_x = 0.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP): rot_x -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN): rot_x += 1
	
	# Aplicamos y limitamos la rotación vertical para no mirar desde abajo de la mesa
	var new_rot_x = rotation.x + rot_x * rotation_speed * delta
	rotation.x = clamp(new_rot_x, -deg_to_rad(75), -deg_to_rad(5))

func _input(event):
	# Zoom con la rueda del ratón
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			spring_arm.spring_length = clamp(spring_arm.spring_length - zoom_speed, min_zoom, max_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			spring_arm.spring_length = clamp(spring_arm.spring_length + zoom_speed, min_zoom, max_zoom)
