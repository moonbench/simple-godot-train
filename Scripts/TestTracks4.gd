extends Node

export var car_count = 4

onready var train_vehicle_reference = load("res://Scenes/TrainVehicle.tscn")
onready var engine = $TrainEngine

func _ready():
	_setup_tracks()
	_setup_train()
	
func _setup_tracks():
	$TestRail.link_track($TrackSwitch, "tail", "head")
	$TrackSwitch.link_track($TestRail2, "left", "head")
	$TrackSwitch.link_track($TestRail3, "right", "head")
	$TrackSwitch2.link_track($TestRail3, "right", "tail")
	$TrackSwitch2.link_track($TestRail6, "left", "tail")
	$TrackSwitch2.link_track($TestRail4, "head", "head")
	$TrackSwitch3.link_track($TestRail2, "right", "tail")
	$TrackSwitch3.link_track($TestRail4, "left", "tail")
	$TrackSwitch3.link_track($TestRail5, "head", "head")
	$TestRail5.link_track($TrackSwitch4, "tail", "head")
	$TrackSwitch4.link_track($TestRail6, "right", "head")
	$TrackSwitch4.link_track($TestRail7, "left", "head")
	$TestRail7.link_track($TestRail, "tail", "head")

func _setup_train():	
	engine.connect("train_info", $TestWorld, "update_train_info")
	engine.add_to_rail($TestRail)
	
	var last_car = engine
	for index in range(car_count):
		var car = train_vehicle_reference.instance()
		add_child(car)
		last_car.set_follower_car(car)
		last_car = car
