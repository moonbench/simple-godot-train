extends Node2D

export var wheel_distance = 54
export var follow_distance = 24
export var mass = 10
var towed_mass = 0
var total_mass = mass

onready var front_wheel = $RailFollower
onready var back_wheel = $RailFollower2
onready var body = $Body

signal towed_mass_changed

class_name TrainVehicle

func _ready():
	front_wheel.connect("moved", back_wheel, "move_as_follower")

func _process(delta):
	global_position = lerp(global_position, front_wheel.global_position, 0.8)
	body.look_at(back_wheel.global_position)
	
func add_to_rail(rail: Path2D):
	front_wheel.set_rail(rail)
	back_wheel.set_rail(rail)
	front_wheel.offset = 1
	front_wheel.place_follower(back_wheel, wheel_distance)	
	global_position = front_wheel.global_position

func set_follower_car(car):
	car.add_to_rail(back_wheel.current_rail)
	back_wheel.place_follower(car.front_wheel, follow_distance)
	car.front_wheel.place_follower(car.back_wheel, car.wheel_distance)
	back_wheel.connect("moved", car.front_wheel, "move_as_follower")
	car.connect("towed_mass_changed", self, "change_towed_mass")
	change_towed_mass(car.mass)

func remove_followr_car(car):
	back_wheel.disconnect("moved", car.front_wheel, "move_as_follower")
	car.disconnect("towed_mass_changed", self, "change_towed_mass")
	change_towed_mass(-car.mass)

func change_towed_mass(mass_delta):
	towed_mass += mass_delta
	total_mass = mass + towed_mass
	emit_signal("towed_mass_changed", mass_delta)
