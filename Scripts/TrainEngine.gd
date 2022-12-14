# Similar to TrainVehicle but it applies power to its front wheel
class_name TrainEngine
extends TrainVehicle

signal train_info

export var max_force = 1000
export var gravity = 9.8
export var friction_coefficient = 0.1
export var rolling_resistance_coefficient = 0.005
export var air_resistance_coefficient = 0.15
export var air_density = 1.0
export var velocity_multiplier = 1.5
var friction_force
var target_force_percent = 0
var applied_force = 0
var velocity = 0

# Update the friction forces that depend on mass when the towed mass changes
func change_towed_mass(mass_delta):
	.change_towed_mass(mass_delta)
	_update_frictions()

# Emit a signal to update the HUD
func _process(_delta):
	emit_signal("train_info", applied_force, max_force, velocity)

# Apply forces
func _physics_process(delta):
	_update_throttle(delta)
	_updated_applied_force(delta)
	if velocity != 0 or applied_force != 0:
		_move_with_friction(delta)

# Move the front wheel by the applied force, minus friction forces
func _move_with_friction(delta):
	var applied_friction = friction_force + (air_resistance_coefficient * air_density * (pow(velocity,2)/2))
	if applied_force == 0 && abs(velocity) < applied_friction / total_mass * delta:
		velocity = 0
	else:
		if velocity > 0:
			velocity = velocity + ((applied_force - applied_friction) / total_mass * delta)
		elif velocity < 0:
			velocity = velocity + ((applied_force + applied_friction) / total_mass * delta)
		else:
			velocity = velocity + (applied_force / total_mass * delta)
	front_wheel.move(velocity * velocity_multiplier * delta)

# Set the "throttle lever" position
func _update_throttle(delta):
	if Input.is_action_pressed("speed_up"):
		target_force_percent = min(target_force_percent + delta/10, 1)
	elif Input.is_action_pressed("slow_down"):
		target_force_percent = max(target_force_percent - delta/10, -1)
	elif Input.is_action_pressed("cut_throttle"):
		target_force_percent = 0

# Lerp the actual engine force from its current value to the throttle position
func _updated_applied_force(delta):
	applied_force = lerp(applied_force, max_force * target_force_percent, delta)
	if abs(applied_force) < 0.1: applied_force = 0

# Recalculate the velocity-independent friction forces for the current mass
func _update_frictions():
	friction_force = friction_coefficient * total_mass * gravity
	friction_force += rolling_resistance_coefficient * total_mass * gravity
