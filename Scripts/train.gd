extends Node2D
class_name Train

signal train_info(stats: Dictionary)

@export var air_density := 1.0
@export var gravity := 9.8
@export var velocity_multiplier := 1.5
@export var throttle_movement_speed := 0.25
@export var brake_application_speed := 1.0
@export var force_change_speed := 1.0

var throttle_percent := 0.0
var brake_percent := 0.0

var cars : Array[TrainVehicle] = []
var first_bogie : Bogie

var total_available_drive_force := 0.0
var total_available_brake_force := 0.0
var total_mass := 0.0
var average_max_speed := 0.0
var average_friction_coefficient := 0.0
var average_rolling_resistance_coefficient := 0.0
var average_air_resistance_coefficient := 0.0

var applied_force := 0.0
var velocity := 0.0
var friction := 0.0
var drag := 0.0
var acceleration := 0.0

func _process(_delta: float) -> void:
	_emit_status()

# Apply forces
func _physics_process(delta: float) -> void:
	_update_applied_force(delta)
	if velocity != 0 or applied_force != 0:
		_move(delta)

#region Public Interface
func add_vehicle(car: TrainVehicle):
	if cars.size() > 0:
		add_vehicle_at_end(car)
	else:
		add_vehicle_at_front(car)

func add_vehicle_at_end(car: TrainVehicle):
	if cars.size() > 0:
		cars.back().set_follower_car(car)
	cars.append(car)
	car.reparent(self)
	_update_physics_from_cars()

func add_vehicle_at_front(car: TrainVehicle):
	cars.push_front(car)
	car.reparent(self)
	_update_physics_from_cars()
	first_bogie = cars[0].front_bogie
#endregion

func _move(delta: float) -> void:
	drag = _drag_force()
	friction = _friction_force()
	var brake = brake_percent * total_available_brake_force
	var resistance = drag + friction + brake
	
	acceleration = 0
	if abs(applied_force) < 1.0 && abs(velocity) < 1.0:
		velocity = 0
	else:
		if velocity > 0:
			acceleration = (applied_force - resistance) / total_mass
		elif velocity < 0:
			acceleration = (applied_force + resistance) / total_mass
		else:
			acceleration = applied_force / total_mass
	
	velocity += acceleration * delta
	if abs(velocity) > 0:
		first_bogie.move(velocity * velocity_multiplier * delta)

# Lerp the actual engine force from its current value to the throttle position
func _update_applied_force(delta: float) -> void:
	var target = 0.0
	if abs(velocity) < average_max_speed:
		target = total_available_drive_force * throttle_percent
	applied_force = lerp(applied_force, target, delta * force_change_speed)

func _friction_force():
	return (average_friction_coefficient * total_mass * gravity) + \
		(average_rolling_resistance_coefficient * total_mass * gravity)

# The air resistance force
func _drag_force():
	return (average_air_resistance_coefficient * air_density * (pow(velocity,2)/2))

func _emit_status():
	train_info.emit({
		"throttle": throttle_percent,
		"force_applied": applied_force,
		"force_max": total_available_drive_force,
		"brake": brake_percent,
		"total_mass": total_mass,
		"velocity": velocity,
		"friction": friction,
		"drag": drag,
		"acceleration": acceleration,
		"max_velocity": average_max_speed,
	})

func _update_physics_from_cars():
	total_mass = 0.0
	total_available_drive_force = 0.0
	total_available_brake_force = 0.0
	
	var friction_coeficient_sum = 0
	var air_resistance_coefficient_sum = 0
	var rolling_resistance_coefficient_sum = 0
	var max_speed_sum = 0
	var engine_count = 0
	
	for car in cars:
		total_mass += car.mass
		friction_coeficient_sum += car.friction_coefficient
		air_resistance_coefficient_sum += car.air_resistance_coefficient
		rolling_resistance_coefficient_sum += rolling_resistance_coefficient_sum
		total_available_brake_force += car.brake_power
		
		if car is TrainEngine:
			total_available_drive_force += car.total_force
			max_speed_sum += car.max_speed
			engine_count += 1
	
	var car_count = float(cars.size())
	average_friction_coefficient = friction_coeficient_sum / car_count
	average_air_resistance_coefficient = air_resistance_coefficient_sum / car_count
	average_rolling_resistance_coefficient = rolling_resistance_coefficient_sum / car_count
	average_max_speed = max_speed_sum / float(engine_count)
