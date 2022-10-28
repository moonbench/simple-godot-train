extends Node2D

onready var force_label = $CanvasLayer/Force
onready var velocity_label = $CanvasLayer/Velocity

func _on_Button_pressed():
	get_tree().change_scene_to(load("res://Scenes/Game.tscn"))

func update_train_info(applied_force, max_force, velocity):
	force_label.text = "Force: %d/%d (%0.1f%%)" % [round(applied_force), max_force, (applied_force/max_force)*100]
	velocity_label.text = "Speed: %0.1f" % (0 if abs(velocity) < 0.1 else velocity)
