@tool
# A node that allows switching between two tracks
#
# Vehicles that enter at the head will be placed on the active track
class_name TrackSwitch
extends Node2D

signal bogie_at_head(bogie: Bogie, extra: float, is_forward: bool)
signal bogie_at_left(bogie: Bogie, extra: float, is_forward: bool)
signal bogie_at_right(bogie: Bogie, extra: float, is_forward: bool)

enum Directions {LEFT, RIGHT}

@export var direction = Directions.RIGHT
@onready var left_track : Track = $LeftTrack
@onready var right_track : Track = $RightTrack
@onready var checkbutton : Button = $Button

func _ready():
	_update_checkbutton()
	_update_sprites()
	checkbutton.focus_mode = Control.FOCUS_NONE

# Change the direction of the switch
func switch():
	if _has_bogies_on():
		_update_checkbutton()
		return
	direction = Directions.LEFT if direction == Directions.RIGHT else Directions.RIGHT
	_update_sprites()
	_update_checkbutton()

func _update_checkbutton():
	checkbutton.button_pressed = true if direction == Directions.RIGHT else Directions.LEFT

# Connect the "from_side" of this track to the "to_side" of the other track
#
# This links both tracks to each other, so only call it once per connection
func link_track(other_track, from_side, to_side):
	connect("bogie_at_" + from_side, Callable(other_track, "enter_from_" + to_side))
	other_track.connect("bogie_at_" + to_side, Callable(self, "enter_from_" + from_side))

# Bogie entering from the head
#
# Place it on the track direction that the switch is set to use
func enter_from_head(bogie: Bogie, extra, is_forward):
	if direction == Directions.LEFT:
		left_track.enter_from_head(bogie, extra, is_forward)
	else:
		right_track.enter_from_head(bogie, extra, is_forward)

# Bogie entering at the left tail
func enter_from_left(bogie: Bogie, extra, is_forward):
	left_track.enter_from_tail(bogie, extra, is_forward)

# Bogie entering at the right tail
func enter_from_right(bogie: Bogie, extra, is_forward):
	right_track.enter_from_tail(bogie, extra, is_forward)

# Check if the switch currently has bogies on it
func _has_bogies_on():
	for child in right_track.get_children():
		if child is Bogie:
			return true
	for child in left_track.get_children():
		if child is Bogie:
			return true

# Update z-index and sprite visibility for current direction
func _update_sprites():
	left_track.get_node("Pointer").hide()
	right_track.get_node("Pointer").hide()
	left_track.z_index = 0
	right_track.z_index = 0
	
	if direction == Directions.RIGHT:
		right_track.get_node("Pointer").show()
		right_track.z_index = 1
	else:
		left_track.get_node("Pointer").show()
		left_track.z_index = 1

func _on_Button_pressed():
	switch()

func _on_right_track_bogie_at_head(bogie: Bogie, extra, is_forward):
	bogie_at_head.emit(bogie, extra, is_forward)

func _on_right_track_bogie_at_tail(bogie: Bogie, extra, is_forward):
	bogie_at_right.emit(bogie, extra, is_forward)

func _on_left_track_bogie_at_head(bogie: Bogie, extra, is_forward):
	bogie_at_head.emit(bogie, extra, is_forward)

func _on_left_track_bogie_at_tail(bogie: Bogie, extra, is_forward):
	bogie_at_left.emit(bogie, extra, is_forward)
