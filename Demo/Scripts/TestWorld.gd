# A background and simple hud for demo scenes
extends Node2D

@export var allows_camera_control := false

@onready var controls_box := %ControlsPanel
@onready var info_box := %InfoBox
@onready var camera_control_box := %ControlsPanel

func _ready():
	camera_control_box.visible = allows_camera_control
	%ControlsButton.toggled.emit(%ControlsButton.button_pressed)
	%InfoButton.toggled.emit(%InfoButton.button_pressed)

func _on_Button_pressed():
	Game.switch_to_scene("res://Demo/Scenes/Game.tscn")

func update_train_info(info):
	info_box.update_info(info)

func _on_info_button_toggled(toggled_on: bool) -> void:
	info_box.visible = toggled_on

func _on_controls_button_toggled(toggled_on: bool) -> void:
	controls_box.visible = toggled_on
