@tool
# A piece of track that Bogie nodes follow along
class_name Track
extends Path2D

signal bogie_at_head(bogie: Bogie, extra: float, is_forward: bool)
signal bogie_at_tail(bogie: Bogie, extra: float, is_forward: bool)

@export var crosstie_distance := 10.0

@onready var line : Line2D = $Line2D
@onready var head_point : PathFollow2D = $HeadPoint
@onready var tail_point : PathFollow2D = $TailPoint
@onready var _crosstie_mesh_instance : MeshInstance2D = $Crosstie
@onready var _crosstie_multimesh : MultiMeshInstance2D = $MultiMeshInstance2D
@onready var curve_points : PackedVector2Array = []

func _ready() -> void:
	curve_points = curve.get_baked_points()
	_update_sprites()
	set_process(Engine.is_editor_hint())

func _process(_delta) -> void:
	# Update the sprites in the editor only if the curve has changed
	var latest_curve_points := curve.get_baked_points()
	if latest_curve_points != curve_points:
		curve_points = latest_curve_points
		_update_sprites()

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

func _update_sprites() -> void:
	line.points = curve_points
	_update_crossties()
	head_point.progress_ratio = 0.0
	tail_point.progress_ratio = 1.0

func _update_crossties() -> void:
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
