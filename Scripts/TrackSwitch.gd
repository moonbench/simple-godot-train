tool
class_name TrackSwitch
extends Node2D

signal wheel_at_head
signal wheel_at_left
signal wheel_at_right

enum Directions {LEFT, RIGHT}

export var direction = Directions.RIGHT
onready var left_track = $LeftTrack
onready var right_track = $RightTrack

func _ready():
	_update_sprites()

func link_track(other_track, from_side, to_side):
	connect("wheel_at_" + from_side, other_track, "enter_from_" + to_side)
	other_track.connect("wheel_at_" + to_side, self, "enter_from_" + from_side)

func enter_from_head(wheel: PathFollow2D, extra, is_forward):
	if direction == Directions.LEFT:
		left_track.enter_from_head(wheel, extra, is_forward)
	else:
		right_track.enter_from_head(wheel, extra, is_forward)

func enter_from_left(wheel: PathFollow2D, extra, is_forward):
	left_track.enter_from_tail(wheel, extra, is_forward)

func enter_from_right(wheel: PathFollow2D, extra, is_forward):
	right_track.enter_from_tail(wheel, extra, is_forward)

func switch():
	if _has_wheels_on(): return
	direction = Directions.LEFT if direction == Directions.RIGHT else Directions.RIGHT
	_update_sprites()

func _has_wheels_on():
	for child in right_track.get_children():
		if child.is_in_group("train_wheels"): return true
	for child in left_track.get_children():
		if child.is_in_group("train_wheels"): return true

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

func _on_RightTrack_wheel_at_tail(wheel, extra, is_forward):
	emit_signal("wheel_at_right", wheel, extra, is_forward)

func _on_LeftTrack_wheel_at_tail(wheel, extra, is_forward):
	emit_signal("wheel_at_left", wheel, extra, is_forward)

func _on_RightTrack_wheel_at_head(wheel, extra, is_forward):
	emit_signal("wheel_at_head", wheel, extra, is_forward)

func _on_LeftTrack_wheel_at_head(wheel, extra, is_forward):
	emit_signal("wheel_at_head", wheel, extra, is_forward)
