extends RigidBody3D

@export var speed: float = 1


func _input(event):
	# Verificamos que sea una tecla presionada y evitamos el "echo" (mantener presionada)
	if event is InputEventKey and event.pressed and not event.echo:
		var impulse := Vector3.ZERO
		
		# Mapeamos WASD a los ejes X y Z
		if event.keycode == KEY_W:
			impulse = Vector3(0, 0, - speed) # Adelante (-Z)
		elif event.keycode == KEY_S:
			impulse = Vector3(0, 0, speed)  # Atrás (+Z)
		elif event.keycode == KEY_A:
			impulse = Vector3(- speed, 0, 0) # Izquierda (-X)
		elif event.keycode == KEY_D:
			impulse = Vector3(speed, 0, 0)  # Derecha (+X)
			
		# Si se generó un impulso con alguna de esas teclas, lo aplicamos
		if impulse != Vector3.ZERO:
			sleeping = false
			apply_central_impulse(impulse)
