extends Area2D

export (NodePath) var parent
export (String) var side
export (bool) var enabled = true
onready var track = get_node(parent)

func _on_TrackJunction_area_entered(area):
	if !enabled || !area.enabled: return
	if area.is_in_group("track_junctions") && area.enabled:
		track.link_track(area.track, side, area.side)
		enabled = false
		area.enabled = false
