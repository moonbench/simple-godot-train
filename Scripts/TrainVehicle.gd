# Sits on top of two TrainWheels to move along a Track
class_name TrainVehicle
extends Node2D

signal towed_mass_changed

export var wheel_distance = 54
export var follow_distance = 24
export var mass = 10

var towed_mass = 0
var total_mass = mass

onready var front_wheel = $RailFollower
onready var back_wheel = $RailFollower2
onready var body = $Body

func _ready():
	front_wheel.connect("moved", back_wheel, "move_as_follower")

func _process(delta):
	global_position = lerp(global_position, front_wheel.global_position, 0.8)
	body.look_at(back_wheel.global_position)
	
func add_to_track(rail: Path2D):
	front_wheel.set_track(rail)
	back_wheel.set_track(rail)
	front_wheel.offset = 1
	back_wheel.follow(front_wheel, wheel_distance)	
	global_position = front_wheel.global_position

func set_follower_car(car):
	car.add_to_track(back_wheel.current_track)
	car.front_wheel.follow(back_wheel, follow_distance)
	car.back_wheel.follow(car.front_wheel, car.wheel_distance)
	back_wheel.connect("moved", car.front_wheel, "move_as_follower")
	car.connect("towed_mass_changed", self, "change_towed_mass")
	change_towed_mass(car.mass)

func remove_follower_car(car):
	back_wheel.disconnect("moved", car.front_wheel, "move_as_follower")
	car.disconnect("towed_mass_changed", self, "change_towed_mass")
	change_towed_mass(-car.mass)

# Share the knowledge of the new total mass
func change_towed_mass(mass_delta):
	towed_mass += mass_delta
	total_mass = mass + towed_mass
	emit_signal("towed_mass_changed", mass_delta)
