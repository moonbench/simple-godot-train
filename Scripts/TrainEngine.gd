# Similar to TrainVehicle but it applies power to its front bogie
class_name TrainEngine
extends TrainVehicle

signal train_info(stats: Dictionary)

@export var max_force := 1000.0
@export var gravity := 9.8
@export var friction_coefficient := 0.1
@export var rolling_resistance_coefficient := 0.005
@export var air_resistance_coefficient := 0.10
@export var air_density := 1.0
@export var velocity_multiplier := 1.5
@export var brake_power := 12.0
@export var brake_application_speed := 5.0

var friction_force := 0.0
var target_force_percent := 0.0
var applied_force := 0.0
var brake_force := 0.0
var velocity := 0.0

func _ready() -> void:
	super()
	_update_frictions()

# Update the friction forces that depend on mass when the towed mass changes
func change_towed_mass(mass_delta: float) -> void:
	super.change_towed_mass(mass_delta)
	_update_frictions()

# Emit a signal to update the HUD
func _process(delta: float) -> void:
	super(delta)
	_update_throttle(delta)
	_update_brake(delta)
	train_info.emit({
		"throttle": target_force_percent,
		"force_applied": applied_force,
		"force_max": max_force,
		"brake": brake_force,
		"total_mass": total_mass,
		"velocity": velocity,
		"friction": friction_force,
		"drag": _drag_force(),
	})

# Apply forces
func _physics_process(delta: float) -> void:
	_updated_applied_force(delta)
	if velocity != 0 or applied_force != 0:
		_move_with_friction(delta)

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if event.is_action_pressed("set_throttle_0"):
			target_force_percent = 0.0
		if event.is_action_pressed("set_throttle_10"):
			target_force_percent = 0.1
		if event.is_action_pressed("set_throttle_20"):
			target_force_percent = 0.2
		if event.is_action_pressed("set_throttle_30"):
			target_force_percent = 0.3
		if event.is_action_pressed("set_throttle_40"):
			target_force_percent = 0.4
		if event.is_action_pressed("set_throttle_50"):
			target_force_percent = 0.5
		if event.is_action_pressed("set_throttle_60"):
			target_force_percent = 0.6
		if event.is_action_pressed("set_throttle_70"):
			target_force_percent = 0.7
		if event.is_action_pressed("set_throttle_80"):
			target_force_percent = 0.8
		if event.is_action_pressed("set_throttle_90"):
			target_force_percent = 0.9
		if event.is_action_pressed("set_throttle_100"):
			target_force_percent = 1.0

# Set the "throttle lever" position
func _update_throttle(delta: float) -> void:
	if Input.is_action_pressed("speed_up"):
		target_force_percent = min(target_force_percent + delta/10, 1)
	elif Input.is_action_pressed("slow_down"):
		target_force_percent = max(target_force_percent - delta/10, -1)
	elif Input.is_action_pressed("cut_throttle"):
		target_force_percent = 0

# Set the percent of the total force with which the brake is being applied
func _update_brake(delta: float) -> void:
	if Input.is_action_pressed("brake"):
		brake_force = clamp(brake_force + brake_application_speed * delta, 0, 1)
	elif brake_force > 0:
		brake_force = clamp(brake_force - brake_application_speed * delta, 0, 1)

# Move the front bogie by the applied force, minus friction forces
func _move_with_friction(delta: float) -> void:
	var resistance = friction_force + _drag_force()
	if applied_force == 0 && abs(velocity) < resistance / total_mass * delta:
		velocity = 0
	else:
		if velocity > 0:
			velocity = velocity + ((applied_force - resistance) / total_mass * delta)
		elif velocity < 0:
			velocity = velocity + ((applied_force + resistance) / total_mass * delta)
		else:
			velocity = velocity + (applied_force / total_mass * delta)
	_apply_brake(delta)
	front_bogie.move(velocity * velocity_multiplier * delta)

# Lerp the actual engine force from its current value to the throttle position
func _updated_applied_force(delta: float) -> void:
	applied_force = lerp(applied_force, max_force * target_force_percent, delta)
	if abs(applied_force) < 0.1: applied_force = 0

# Recalculate the velocity-independent friction forces for the current mass
func _update_frictions():
	friction_force = friction_coefficient * total_mass * gravity
	friction_force += rolling_resistance_coefficient * total_mass * gravity

# The air resistance force
func _drag_force():
	return (air_resistance_coefficient * air_density * (pow(velocity,2)/2))

# Reduce the velocity based on applied brake power
func _apply_brake(delta: float) -> void:
	if velocity == 0: return
	elif velocity > 0:
		velocity = max(velocity - brake_force * brake_power * delta, 0)
	elif velocity < 0:
		velocity = min(velocity + brake_force * brake_power * delta, 0)
