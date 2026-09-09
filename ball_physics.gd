extends RigidBody3D
## Lightweight rolling resistance for realistic pool ball physics.
## Godot's built-in friction only handles sliding (Coulomb friction), not the
## energy lost when a ball rolls over a deformable surface like felt. This script
## adds that missing rolling resistance as a gentle decelerating force.

# =============================================================================
#  TUNING CONSTANTS — adjust these to change how the table "feels"
# =============================================================================

## Rolling resistance coefficient. Simulates felt deformation under the ball.
## Real pool cloth is roughly 0.005–0.015. Increase for a "slower" table.
@export var rolling_resistance: float = 0.01

## Speed (m/s) below which the ball is forced to rest.
## Prevents micro-jitter when nearly stationary. 5 mm/s is imperceptible.
@export var sleep_speed: float = 0.005

## Ball radius in meters — must match the SphereShape3D collision shape.
@export var ball_radius: float = 0.02865

# =============================================================================

func _physics_process(_delta: float) -> void:
	var speed := linear_velocity.length()

	# ---- Stop cleanly when nearly at rest ----
	if speed < sleep_speed:
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		return

	# ---- Rolling resistance ----
	# F_rolling = μ_r × m × g  (constant magnitude, opposite to velocity)
	# This is the standard rolling-resistance formula from physics.
	var gravity: float = ProjectSettings.get_setting(
		"physics/3d/default_gravity", 9.8
	)
	var resistance_force: float = rolling_resistance * mass * gravity
	var decel_direction: Vector3 = linear_velocity.normalized()
	apply_central_force(-decel_direction * resistance_force)

	# ---- Proper visual rolling ----
	# For a sphere rolling without slipping: ω = v / r
	# Rotation axis = UP × velocity_direction  (perpendicular to both)
	var roll_axis: Vector3 = Vector3.UP.cross(decel_direction)
	if roll_axis.length_squared() > 0.000001:
		var target_angular_speed: float = speed / ball_radius
		var target_angular: Vector3 = roll_axis.normalized() * target_angular_speed
		# Gently blend toward correct rolling — avoids fighting the physics
		# engine during collisions or spin shots.
		angular_velocity = angular_velocity.lerp(target_angular, 0.1)
