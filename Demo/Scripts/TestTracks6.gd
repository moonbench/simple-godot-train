extends Node

func _ready() -> void:
	UI.add_driving_ui()

func _setup_train():
	var train = load("res://Scenes/train.tscn").instantiate()
	add_child(train)
	
	train.enable_player_control()
	var engine = load("res://Scenes/TrainEngine.tscn").instantiate()
	add_child(engine)
	engine.add_to_track($Tracks/Track, 1200)
	var camera : Camera2D = load("res://Demo/Scenes/ChaseCamera.tscn").instantiate()
	camera.ignore_rotation = false
	camera.rotation = -PI/2
	engine.add_child(camera)
	train.add_vehicle(engine)
	
	var e2 = load("res://Scenes/TrainEngine.tscn").instantiate()
	add_child(e2)
	train.add_vehicle(e2)

	for _i in range(30):
		_add_car_to_train(train)
	
	UI.add_driving_ui()
	train.train_info.connect(UI.driving_ui.update_train_info)
	
	

func _add_car_to_train(train: Train) -> void:
	var car = load("res://Scenes/TrainVehicle.tscn").instantiate()
	add_child(car)
	train.add_vehicle(car)

func _on_timer_timeout() -> void:
	_setup_train()
