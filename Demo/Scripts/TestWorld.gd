# A background and simple hud for demo scenes
extends Node2D

onready var throttle_label = $CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer2/InfoBox/MarginContainer/VBoxContainer/HBoxContainer/Throttle
onready var force_label = $CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer2/InfoBox/MarginContainer/VBoxContainer/HBoxContainer2/Force
onready var velocity_label = $CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer2/InfoBox/MarginContainer/VBoxContainer/HBoxContainer3/Velocity
onready var mass_label = $CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer2/InfoBox/MarginContainer/VBoxContainer/HBoxContainer4/Mass
onready var friction_label = $CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer2/InfoBox/MarginContainer/VBoxContainer/HBoxContainer5/Friction
onready var drag_label = $CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer2/InfoBox/MarginContainer/VBoxContainer/HBoxContainer6/Drag


func _on_Button_pressed():
	get_tree().change_scene_to(load("res://Demo/Scenes/Game.tscn"))

func update_train_info(info):
	throttle_label.text = "%0.1f%%" % (info["throttle"]*100)
	force_label.text = "%d/%d (%0.1f%%)" % [round(info["force_applied"]), info["force_max"], (info["force_applied"]/info["force_max"])*100]
	velocity_label.text = "%0.1f" % (0 if abs(info["velocity"]) < 0.1 else info["velocity"])
	mass_label.text = "%0.1f" % info["total_mass"]
	friction_label.text = "%0.1f" % info["friction"]
	drag_label.text = "%0.1f" % info["drag"]
