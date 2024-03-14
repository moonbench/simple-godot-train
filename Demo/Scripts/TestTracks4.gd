extends Node
func _setup_train():
	var train = load("res://Scenes/train.tscn").instantiate()
	add_child(train)
	
	train.add_child(load("res://Scenes/components/player_control_component.tscn").instantiate())
	var engine = load("res://Scenes/TrainEngine.tscn").instantiate()
	add_child(engine)
	engine.add_to_track($Tracks/Track, 1200)
	train.add_vehicle(engine)
	
	var e2 = load("res://Scenes/TrainEngine.tscn").instantiate()
	add_child(e2)
	train.add_vehicle(e2)

	for _i in range(14):
		_add_car_to_train(train)
	
	UI.add_driving_ui()
	train.train_info.connect(UI.driving_ui.update_train_info)
	
	engine.add_child(load("res://Demo/Scenes/ChaseCamera.tscn").instantiate())

func _add_car_to_train(train: Train) -> void:
	var car = load("res://Scenes/TrainVehicle.tscn").instantiate()
	add_child(car)
	train.add_vehicle(car)

func _on_timer_timeout() -> void:
	_setup_train()
