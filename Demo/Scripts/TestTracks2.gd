extends Node

export var car_count = 8

onready var train_vehicle_reference = load("res://Scenes/TrainVehicle.tscn")

func _ready():
	_setup_tracks()
	_setup_train()
	
func _setup_tracks():
	$TestRail.link_track($TrackSwitch, "tail", "head")
	$TrackSwitch.link_track($TestRail4, "right", "tail")
	$TrackSwitch.link_track($TestRail2, "left", "head")
	$TestRail2.link_track($TrackSwitch3, "tail", "right")
	$TrackSwitch3.link_track($TestRail3, "head", "head")
	$TestRail3.link_track($TrackSwitch2, "tail", "head")
	$TrackSwitch2.link_track($TestRail, "left", "head")
	$TrackSwitch2.link_track($TestRail5, "right", "head")
	$TestRail5.link_track($TrackSwitch4, "tail", "left")
	$TrackSwitch4.link_track($TrackSwitch3, "head", "left")
	$TrackSwitch4.link_track($TestRail4, "right", "head")

func _setup_train():
	$TrainEngine.connect("train_info", $TestWorld, "update_train_info")
	$TrainEngine.add_to_track($TestRail)
	
	var last_car = $TrainEngine
	for index in range(car_count):
		var car = train_vehicle_reference.instance()
		add_child(car)
		last_car.set_follower_car(car)
		last_car = car
