# Runs the demo's main scene
extends Node

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
