extends Area2D
class_name Junction

@export var parent : NodePath
@export var side : String
@export var enabled := true
@onready var track = get_node(parent)

func _on_TrackJunction_area_entered(area: Junction) -> void:
	if !enabled || !area.enabled:
		return
	
	track.link_track(area.track, side, area.side)
	enabled = false
	area.enabled = false
