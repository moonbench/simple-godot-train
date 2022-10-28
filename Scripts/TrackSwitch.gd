extends Node2D

enum DIRECTIONS {LEFT, RIGHT}
export var direction = DIRECTIONS.RIGHT

onready var left_track = $LeftTrack
onready var right_track = $RightTrack

signal wheel_at_head
signal wheel_at_left
signal wheel_at_right

func _ready():
	_update_track_visuals()

func enter_from_head(wheel: PathFollow2D, extra, is_forward):
	if direction == DIRECTIONS.LEFT:
		left_track.enter_from_head(wheel, extra, is_forward)
	else:
		right_track.enter_from_head(wheel, extra, is_forward)

func enter_from_left(wheel: PathFollow2D, extra, is_forward):
	left_track.enter_from_tail(wheel, extra, is_forward)

func enter_from_right(wheel: PathFollow2D, extra, is_forward):
	right_track.enter_from_tail(wheel, extra, is_forward)

func _on_Button_pressed():
	 switch()

func switch():
	direction = DIRECTIONS.LEFT if direction == DIRECTIONS.RIGHT else DIRECTIONS.RIGHT
	_update_track_visuals()

func _update_track_visuals():
	left_track.get_node("Pointer").hide()
	right_track.get_node("Pointer").hide()
	left_track.z_index = 0
	right_track.z_index = 0
	
	if direction == DIRECTIONS.RIGHT:
		right_track.get_node("Pointer").show()
		right_track.z_index = 1
	else:
		left_track.get_node("Pointer").show()
		left_track.z_index = 1

func link_track(other_track, from_side, to_side):
	connect("wheel_at_" + from_side, other_track, "enter_from_" + to_side)
	other_track.connect("wheel_at_" + to_side, self, "enter_from_" + from_side)

func _on_RightTrack_wheel_at_tail(wheel, extra, is_forward):
	emit_signal("wheel_at_right", wheel, extra, is_forward)

func _on_LeftTrack_wheel_at_tail(wheel, extra, is_forward):
	emit_signal("wheel_at_left", wheel, extra, is_forward)

func _on_RightTrack_wheel_at_head(wheel, extra, is_forward):
	emit_signal("wheel_at_head", wheel, extra, is_forward)

func _on_LeftTrack_wheel_at_head(wheel, extra, is_forward):
	emit_signal("wheel_at_head", wheel, extra, is_forward)
