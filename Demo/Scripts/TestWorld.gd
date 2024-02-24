# A background and simple hud for demo scenes
extends Node2D

@export var allows_camera_control = false

@onready var throttle_label = $CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer2/InfoBox/MarginContainer/VBoxContainer/HBoxContainer/Throttle
@onready var force_label = $CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer2/InfoBox/MarginContainer/VBoxContainer/HBoxContainer2/Force
@onready var brake_label = $CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer2/InfoBox/MarginContainer/VBoxContainer/HBoxContainer7/Brake
@onready var velocity_label = $CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer2/InfoBox/MarginContainer/VBoxContainer/HBoxContainer3/Velocity
@onready var mass_label = $CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer2/InfoBox/MarginContainer/VBoxContainer/HBoxContainer4/Mass
@onready var friction_label = $CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer2/InfoBox/MarginContainer/VBoxContainer/HBoxContainer5/Friction
@onready var drag_label = $CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer2/InfoBox/MarginContainer/VBoxContainer/HBoxContainer6/Drag
@onready var controls_box = $CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/ControlsPanel
@onready var info_box = $CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer2/InfoBox
@onready var camera_control_box = $CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/ControlsPanel/VBoxContainer/CameraInfoControls


func _ready():
	camera_control_box.visible = allows_camera_control
	$CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/PanelContainer/VBoxContainer/ControlsButton.focus_mode = Control.FOCUS_NONE
	$CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/PanelContainer/VBoxContainer/InfoButton.focus_mode = Control.FOCUS_NONE

func _on_Button_pressed():
	get_tree().change_scene_to_packed(load("res://Demo/Scenes/Game.tscn"))

func update_train_info(info):
	throttle_label.text = "%0.1f%%" % (info["throttle"]*100)
	force_label.text = "%d/%d (%0.1f%%)" % [round(info["force_applied"]), info["force_max"], (info["force_applied"]/info["force_max"])*100]
	brake_label.text = "%0.1f%%" % (info["brake"]*100)
	velocity_label.text = "%0.1f" % (0 if abs(info["velocity"]) < 0.1 else info["velocity"])
	mass_label.text = "%0.1f" % info["total_mass"]
	friction_label.text = "%0.1f" % info["friction"]
	drag_label.text = "%0.1f" % info["drag"]

func _on_Button2_pressed():
	if controls_box.visible:
		controls_box.hide()
	else:
		controls_box.show()

func _on_InfoButton_pressed():
	if info_box.visible:
		info_box.hide()
	else:
		info_box.show()
