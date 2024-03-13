extends Node2D

@export var driving_ui_source : PackedScene

var driving_ui : CanvasLayer
@onready var transitions := $TransitionsLayer

func add_driving_ui():
	remove_driving_ui()
	driving_ui = driving_ui_source.instantiate()
	add_child(driving_ui)

func remove_driving_ui():
	if driving_ui:
		driving_ui.queue_free()
	driving_ui = null
