extends Node

export var car_count = 4

onready var train_vehicle_reference = load("res://Scenes/TrainVehicle.tscn")

func _ready():
	_setup_tracks()
	_setup_train()
	
func _setup_tracks():
	$TestRail.link_track($TestRail2, "tail", "head")
	$TestRail2.link_track($TrackSwitch2, "tail", "left")
	$TrackSwitch2.link_track($TestRail3, "head", "head")
	$TestRail3.link_track($TrackSwitch, "tail", "head")
	$TrackSwitch.link_track($TestRail4, "right", "head")
	$TrackSwitch.link_track($TestRail5, "left", "head")
	$TestRail4.link_track($TestRail, "tail", "head")
	$TestRail5.link_track($TrackSwitch2, "tail", "right")

func _setup_train():
	$TrainEngine.connect("train_info", $TestWorld, "update_train_info")
	$TrainEngine.add_to_rail($TestRail)
	
	var last_car = $TrainEngine
	for index in range(car_count):
		var car = train_vehicle_reference.instance()
		add_child(car)
		last_car.set_follower_car(car)
		last_car = car
