extends Node

export var car_count = 12

onready var train_vehicle_reference = load("res://Scenes/TrainVehicle.tscn")
onready var engine = $TrainEngine

func _ready():
	_setup_tracks()
	_setup_train()
	
func _setup_tracks():
	$TrackSwitch4.link_track($TestRail, "head", "head")
	$TrackSwitch4.link_track($TestRail5, "right", "tail")
	$TrackSwitch4.link_track($TestRail15, "left", "head")
	$TrackSwitch.link_track($TestRail, "right", "tail")
	$TrackSwitch.link_track($TestRail2, "head", "head")
	$TrackSwitch.link_track($TestRail14, "left", "tail")
	$TrackSwitch2.link_track($TestRail2, "head", "tail")
	$TrackSwitch2.link_track($TestRail3, "left", "head")
	$TrackSwitch2.link_track($TestRail12, "right", "head")
	$TrackSwitch3.link_track($TestRail3, "head", "tail")
	$TrackSwitch3.link_track($TestRail4, "left", "head")
	$TrackSwitch3.link_track($TrackSwitch5, "right", "head")
	$TestRail4.link_track($TestRail5, "tail", "head")
	$TrackSwitch5.link_track($TestRail6, "left", "head")
	$TrackSwitch5.link_track($TrackSwitch7, "right", "head")
	$TestRail6.link_track($TestRail16, "tail", "head")
	$TestRail16.link_track($TestRail17, "tail", "head")
	$TestRail17.link_track($TestRail18, "tail", "head")
	$TestRail18.link_track($TestRail19, "tail", "head")
	$TestRail19.link_track($TestRail11, "tail", "head")
	$TrackSwitch7.link_track($TestRail7, "left", "head")
	$TrackSwitch7.link_track($TestRail9, "right", "head")
	$TrackSwitch6.link_track($TestRail11, "head", "tail")
	$TrackSwitch6.link_track($TestRail7, "right", "tail")
	$TrackSwitch6.link_track($TestRail8, "left", "tail")
	$TrackSwitch8.link_track($TestRail8, "right", "head")
	$TrackSwitch8.link_track($TestRail9, "left", "tail")
	$TrackSwitch8.link_track($TestRail10, "head", "head")
	$TrackSwitch9.link_track($TestRail10, "head", "tail")
	$TrackSwitch9.link_track($TestRail12, "right", "tail")
	$TrackSwitch9.link_track($TestRail13, "left", "tail")
	$TrackSwitch10.link_track($TestRail14, "left", "head")
	$TrackSwitch10.link_track($TestRail13, "right", "head")
	$TrackSwitch10.link_track($TestRail15, "head", "tail")
	

func _setup_train():
	engine.connect("train_info", $TestWorld, "update_train_info")
	engine.add_to_rail($TestRail)
	
	var last_car = engine
	for index in range(car_count):
		var car = train_vehicle_reference.instance()
		add_child(car)
		last_car.set_follower_car(car)
		last_car = car
