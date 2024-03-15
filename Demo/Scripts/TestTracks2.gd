extends Node

func _ready() -> void:
	UI.add_driving_ui()

func _setup_train():
	var train = load("res://Scenes/train.tscn").instantiate()
	add_child(train)
	
	train.enable_player_control()
	var engine = load("res://Scenes/TrainEngine.tscn").instantiate()
	add_child(engine)
	engine.add_to_track($Tracks/Track, 900)
	train.add_vehicle(engine)
	
	for _i in range(6):
		_add_car_to_train(train)
	
	train.train_info.connect(UI.driving_ui.update_train_info)

func _add_car_to_train(train: Train) -> void:
	var car = load("res://Scenes/TrainVehicle.tscn").instantiate()
	add_child(car)
	train.add_vehicle(car)

func _on_timer_timeout() -> void:
	_setup_train()
