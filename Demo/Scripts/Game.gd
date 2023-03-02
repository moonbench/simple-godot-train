# Runs the demo's main scene
extends Node

export var car_count = 6

onready var train_vehicle_reference = load("res://Scenes/TrainVehicle.tscn")
onready var engine = $TrainEngine

func _setup_train():
	engine.add_to_track($Tracks/Track, 400)
	
	var last_car = engine
	for index in range(car_count):
		var car = train_vehicle_reference.instance()
		add_child(car)
		last_car.set_follower_car(car)
		last_car = car

func _on_Timer_timeout():
	_setup_train()

func _on_Button_pressed():
	get_tree().change_scene_to(load("res://Demo/Scenes/TestTracks1.tscn"))

func _on_Button2_pressed():
	get_tree().change_scene_to(load("res://Demo/Scenes/TestTracks2.tscn"))

func _on_Button3_pressed():
	get_tree().change_scene_to(load("res://Demo/Scenes/TestTracks3.tscn"))

func _on_Button4_pressed():
	get_tree().change_scene_to(load("res://Demo/Scenes/TestTracks4.tscn"))

func _on_Button5_pressed():
	get_tree().change_scene_to(load("res://Demo/Scenes/TestTracks5.tscn"))

func _on_Button6_pressed():
	get_tree().change_scene_to(load("res://Demo/Scenes/TestTracks6.tscn"))
