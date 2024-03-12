@tool
# A piece of track that Bogie nodes follow along
class_name Track
extends Path2D

signal bogie_at_head(bogie: Bogie, extra: float, is_forward: bool)
signal bogie_at_tail(bogie: Bogie, extra: float, is_forward: bool)

@export var crosstie_distance = 10
@onready var _crosstie_mesh_instance = $Crosstie
@onready var _crosstie_multimesh = $MultiMeshInstance2D
@onready var curve_points = []

func _ready():
	curve_points = curve.get_baked_points()
	_update_sprites()

func _process(_delta):
	if Engine.is_editor_hint():
		# Update the sprites in the editor only if the curve has changed
		var latest_curve_points := curve.get_baked_points()
		if latest_curve_points != curve_points:
			curve_points = latest_curve_points
			_update_sprites()

# Connect the "from_side" of this track to the "to_side" of the other track
#
# This links both tracks to each other, so only call it once per connection
func link_track(other_track, from_side, to_side):
	connect("bogie_at_" + from_side, Callable(other_track, "enter_from_" + to_side))
	other_track.connect("bogie_at_" + to_side, Callable(self, "enter_from_" + from_side))

# A bogie enters from the head side
func enter_from_head(bogie: Bogie, extra, is_forward):
	bogie.set_track(self)
	bogie.progress = extra
	bogie.head_to_tail() if is_forward else bogie.tail_to_head()

# A bogie enters from the tail side
func enter_from_tail(bogie: Bogie, extra, is_forward):
	bogie.set_track(self)
	bogie.progress_ratio = 1
	bogie.progress -= extra
	bogie.tail_to_head() if is_forward else bogie.head_to_tail()

# The bogie has reached the head
func on_bogie_at_head(bogie: Bogie, extra: float, is_forward: bool):
	bogie_at_head.emit(bogie, extra, is_forward)

# The bogie has reached the tail
func on_bogie_at_tail(bogie: Bogie, extra: float, is_forward: bool):
	bogie_at_tail.emit(bogie, extra, is_forward)

func _update_sprites():
	$Line2D.points = curve_points
	_update_crossties()
	$HeadPoint.progress_ratio = 0
	$TailPoint.progress_ratio = 1

func _update_crossties():
	var crossties = _crosstie_multimesh.multimesh
	crossties.mesh = _crosstie_mesh_instance.mesh
	
	var curve_length = curve.get_baked_length()
	var crosstie_count = round(curve_length / crosstie_distance)
	crossties.instance_count = crosstie_count
	
	for i in range(crosstie_count):
		var t = Transform2D()
		var crosstie_position = curve.sample_baked((i * crosstie_distance) + crosstie_distance / 2.0)
		var next_position = curve.sample_baked((i + 1) * crosstie_distance)
		t = t.rotated((next_position - crosstie_position).normalized().angle())
		t.origin = crosstie_position
		crossties.set_instance_transform_2d(i, t)
