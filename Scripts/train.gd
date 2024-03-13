extends Node2D
class_name Train

signal train_info(stats: Dictionary)

@export var air_density := 1.0
@export var gravity := 9.8
@export var velocity_multiplier := 1.5
@export var brake_application_speed := 1.0

@onready var remote_xform := $RemoteTransform2D

var max_force := 0.0
var total_brake_power := 0.0
var total_mass := 0.0

var average_friction_coefficient := 0.1
var average_rolling_resistance_coefficient := 0.005
var average_air_resistance_coefficient := 0.10

var target_force_percent := 0.0
var applied_force := 0.0
var brake_force := 0.0
var velocity := 0.0

var cars : Array[TrainVehicle] = []
var first_bogie : Bogie

func _ready() -> void:
	$Label.text = str(self)
	if first_bogie:
		remote_xform.reparent(first_bogie, false)
		remote_xform.remote_path = remote_xform.get_path_to(self)

func _process(delta: float) -> void:
	_emit_status()

# Apply forces
func _physics_process(delta: float) -> void:
	_updated_applied_force(delta)
	if velocity != 0 or applied_force != 0:
		_move_with_friction(delta)

# Move the front bogie by the applied force, minus friction forces
func _move_with_friction(delta: float) -> void:
	var resistance = _friction_force() + _drag_force()
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
	first_bogie.move(velocity * velocity_multiplier * delta)

# Reduce the velocity based on applied brake power
func _apply_brake(delta: float) -> void:
	if velocity == 0: return
	elif velocity > 0:
		velocity = max(velocity - brake_force * total_brake_power * delta, 0)
	elif velocity < 0:
		velocity = min(velocity + brake_force * total_brake_power * delta, 0)

# Lerp the actual engine force from its current value to the throttle position
func _updated_applied_force(delta: float) -> void:
	applied_force = lerp(applied_force, max_force * target_force_percent, delta)
	if abs(applied_force) < 0.1: applied_force = 0

func add_vehicle(car: TrainVehicle):
	add_vehicle_at_end(car)

func add_vehicle_at_end(car: TrainVehicle):
	if cars.size() > 0:
		cars.back().set_follower_car(car)
	cars.append(car)
	car.reparent(self)
	_sync_references()

func add_vehicle_at_front(car: TrainVehicle):
	cars.push_front(car)
	car.reparent(self)
	_sync_references()

func _sync_references():
	total_mass = 0.0
	total_brake_power = 0.0
	max_force = 0.0
	
	for car in cars:
		total_mass += car.mass
		total_brake_power += car.brake_power
		
		if car is TrainEngine:
			max_force += car.max_force
	
	first_bogie = cars[0].front_bogie
	
	if remote_xform:
		remote_xform.reparent(first_bogie, false)
		remote_xform.remote_path = remote_xform.get_path_to(self)

func _emit_status():
	train_info.emit({
		"throttle": target_force_percent,
		"force_applied": applied_force,
		"force_max": max_force,
		"brake": brake_force,
		"total_mass": total_mass,
		"velocity": velocity,
		"friction": _friction_force(),
		"drag": _drag_force(),
	})

func _friction_force():
	var friction_force = average_friction_coefficient * total_mass * gravity
	friction_force += average_rolling_resistance_coefficient * total_mass * gravity
	return friction_force

# The air resistance force
func _drag_force():
	return (average_air_resistance_coefficient * air_density * (pow(velocity,2)/2))
