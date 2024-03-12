@tool
# A piece of track that Bogie nodes follow along
class_name Track
extends Path2D

signal points_changed
signal bogie_at_head(bogie: Bogie, extra: float, is_forward: bool)
signal bogie_at_tail(bogie: Bogie, extra: float, is_forward: bool)

@onready var head_point : PathFollow2D = $HeadPoint
@onready var tail_point : PathFollow2D = $TailPoint
@onready var curve_points : PackedVector2Array = []

func _ready() -> void:
	_update_points()
	set_process(Engine.is_editor_hint())

func _process(_delta: float) -> void:
	# Update the sprites in the editor only if the curve has changed
	if curve.get_baked_points() != curve_points:
		_update_points()

# Connect the "from_side" of this track to the "to_side" of the other track
#
# This links both tracks to each other, so only call it once per connection
func link_track(other_track, from_side: String, to_side: String) -> void:
	connect("bogie_at_" + from_side, Callable(other_track, "enter_from_" + to_side))
	other_track.connect("bogie_at_" + to_side, Callable(self, "enter_from_" + from_side))

# A bogie enters from the head side
func enter_from_head(bogie: Bogie, extra: float, is_forward: bool) -> void:
	bogie.set_track(self)
	bogie.progress = extra
	bogie.head_to_tail() if is_forward else bogie.tail_to_head()

# A bogie enters from the tail side
func enter_from_tail(bogie: Bogie, extra: float, is_forward: bool) -> void:
	bogie.set_track(self)
	bogie.progress_ratio = 1
	bogie.progress -= extra
	bogie.tail_to_head() if is_forward else bogie.head_to_tail()

# The bogie has reached the head
func on_bogie_at_head(bogie: Bogie, extra: float, is_forward: bool) -> void:
	bogie_at_head.emit(bogie, extra, is_forward)

# The bogie has reached the tail
func on_bogie_at_tail(bogie: Bogie, extra: float, is_forward: bool) -> void:
	bogie_at_tail.emit(bogie, extra, is_forward)

func _update_points():
	curve_points = curve.get_baked_points()
	_update_head_and_tail()
	points_changed.emit()

func _update_head_and_tail():
	head_point.progress_ratio = 0.0
	tail_point.progress_ratio = 1.0
