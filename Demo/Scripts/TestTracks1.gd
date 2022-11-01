extends Node

export var car_count = 8

onready var train_vehicle_reference = load("res://Scenes/TrainVehicle.tscn")
onready var engine = $TrainEngine

func _ready():
	_setup_tracks()
	_setup_train()
	
func _setup_tracks():
	$TrainEngine.connect("train_info", $TestWorld, "update_train_info")
	$TestRail.link_track($TestRail, "tail", "head")

func _setup_train():
	engine.add_to_track($TestRail)
	
	var last_car = engine
	for index in range(car_count):
		var car = train_vehicle_reference.instance()
		add_child(car)
		last_car.set_follower_car(car)
		last_car = car
