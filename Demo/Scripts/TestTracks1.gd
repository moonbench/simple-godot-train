extends Node

@export var car_count = 8
@export var train_vehicle_reference : PackedScene

@onready var engine : TrainEngine = $TrainEngine

func _setup_train():
	UI.add_driving_ui()
	engine.train_info.connect(UI.driving_ui.update_train_info)
	engine.add_to_track($Tracks/Track, 300)
	
	var last_car = engine
	for index in range(car_count):
		var car = train_vehicle_reference.instantiate()
		add_child(car)
		last_car.set_follower_car(car)
		last_car = car

func _on_timer_timeout() -> void:
	_setup_train()
