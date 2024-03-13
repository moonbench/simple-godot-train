# Runs the demo's main scene
extends Node

@export var car_count := 12

@onready var train_vehicle_reference = load("res://Scenes/TrainVehicle.tscn")
@onready var engine : TrainEngine = $TrainEngine

func _ready() -> void:
	_setup_train.call_deferred()
	UI.remove_driving_ui()

func _setup_train():
	engine.add_to_track($Tracks/Track, 200)
	engine.target_force_percent = 0.5
	engine.velocity = 46.0
	
	var last_car = engine
	for index in range(car_count):
		var car = train_vehicle_reference.instantiate()
		add_child(car)
		last_car.set_follower_car(car)
		last_car = car

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
