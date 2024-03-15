# Runs the demo's main scene
extends Node

func _ready() -> void:
	_setup_train.call_deferred()
	UI.remove_driving_ui()

func _on_Button_pressed():
	Game.switch_to_scene("res://Demo/Scenes/TestTracks1.tscn")

func _on_Button2_pressed():
	Game.switch_to_scene("res://Demo/Scenes/TestTracks2.tscn")

func _on_Button3_pressed():
	Game.switch_to_scene("res://Demo/Scenes/TestTracks3.tscn")

func _on_Button4_pressed():
	Game.switch_to_scene("res://Demo/Scenes/TestTracks4.tscn")

func _on_Button5_pressed():
	Game.switch_to_scene("res://Demo/Scenes/TestTracks5.tscn")

func _on_Button6_pressed():
	Game.switch_to_scene("res://Demo/Scenes/TestTracks6.tscn")

func _on_version_pressed() -> void:
	OS.shell_open("https://github.com/moonbench/simple-godot-train") 

func _on_exit_button_pressed() -> void:
	Game.exit()

func _setup_train():
	var train = load("res://Scenes/train.tscn").instantiate()
	add_child(train)
	
	train.add_child(load("res://Scenes/components/player_control_component.tscn").instantiate())
	var engine = load("res://Scenes/TrainEngine.tscn").instantiate()
	add_child(engine)
	engine.add_to_track($Tracks/Track, 300)
	train.add_vehicle(engine)
	
	var e2 = load("res://Scenes/TrainEngine.tscn").instantiate()
	add_child(e2)
	train.add_vehicle(e2)

	for _i in range(14):
		_add_car_to_train(train)

	train.throttle_percent = 0.4
	train.velocity = 42.0

func _add_car_to_train(train: Train) -> void:
	var car = load("res://Scenes/TrainVehicle.tscn").instantiate()
	add_child(car)
	train.add_vehicle(car)
