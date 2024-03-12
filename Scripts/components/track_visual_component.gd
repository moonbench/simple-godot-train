@tool
extends Line2D

@export var crosstie_distance := 10.0 : set = set_crosstie_distance

@onready var _crosstie_mesh_instance : MeshInstance2D = $Crosstie
@onready var _crosstie_multimesh : MultiMeshInstance2D = $MultiMeshInstance2D
@onready var track : Track = get_parent()

func _on_track_points_changed() -> void:
	points = track.curve_points
	_update_crossties()
	
func _update_crossties() -> void:
	if !_crosstie_multimesh:
		return
	
	var crossties = _crosstie_multimesh.multimesh
	crossties.mesh = _crosstie_mesh_instance.mesh
	
	var curve_length = track.curve.get_baked_length()
	var crosstie_count = round(curve_length / crosstie_distance)
	crossties.instance_count = crosstie_count
	
	for i in range(crosstie_count):
		var t = Transform2D()
		var crosstie_position = track.curve.sample_baked((i * crosstie_distance) + crosstie_distance / 2.0)
		var next_position = track.curve.sample_baked((i + 1) * crosstie_distance)
		t = t.rotated((next_position - crosstie_position).normalized().angle())
		t.origin = crosstie_position
		crossties.set_instance_transform_2d(i, t)

func set_crosstie_distance(new_dist: float) -> void:
	crosstie_distance = new_dist
	_update_crossties()
