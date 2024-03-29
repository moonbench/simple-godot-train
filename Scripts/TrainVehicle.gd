# Sits on top of two Bogies to move along a Track
class_name TrainVehicle
extends Node2D

signal towed_mass_changed(mass_delta: float)

@export var bogie_distance := 58.0
@export var follow_distance := 26.0
@export var mass := 10.0

var towed_mass := 0.0
var total_mass := mass

@onready var front_bogie : Bogie = $Bogie
@onready var back_bogie : Bogie = $Bogie2
@onready var body : Node2D = $Body

func _ready() -> void:
	front_bogie.moved.connect(back_bogie.move_as_follower)

func _process(_delta: float) -> void:
	global_position = lerp(global_position, front_bogie.global_position, 0.8)
	body.look_at(back_bogie.global_position)

# Place this vehicle (and all of its bogies) on the track
func add_to_track(track: Track, offset : float = 1.0) -> void:
	front_bogie.set_track(track)
	back_bogie.set_track(track)
	front_bogie.progress = offset
	back_bogie.follow(front_bogie, bogie_distance)
	global_position = front_bogie.global_position

# Link another TrainVehicle to follow this one
func set_follower_car(car: TrainVehicle) -> void:
	car.add_to_track(back_bogie.current_track)
	car.front_bogie.follow(back_bogie, follow_distance)
	car.back_bogie.follow(car.front_bogie, car.bogie_distance)
	back_bogie.moved.connect(car.front_bogie.move_as_follower)
	car.towed_mass_changed.connect(change_towed_mass)
	change_towed_mass(car.total_mass)

# Disconnect this car's signals from its followers
func remove_follower_car(car: TrainVehicle) -> void:
	back_bogie.moved.disconnect(car.front_bogie.move_as_follower)
	car.towed_mass_changed.disconnect(change_towed_mass)
	change_towed_mass(-car.total_mass)

# Share the knowledge of the new total mass
func change_towed_mass(mass_delta: float) -> void:
	towed_mass += mass_delta
	total_mass = mass + towed_mass
	towed_mass_changed.emit(mass_delta)

func _on_RailFollower_track_changed() -> void:
	add_to_track(front_bogie.get_parent(), front_bogie.offset)
