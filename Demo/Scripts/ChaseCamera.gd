extends Camera2D

@export var min_zoom := 0.4
@export var max_zoom := 4.0
@export var zoom_step := 0.1
@export var zoom_speed := 2.0

var desired_zoom = zoom.x

func _process(delta):
	if zoom.x != desired_zoom:
		zoom.x = clamp(
			lerp(zoom.x, desired_zoom, delta * zoom_speed),
			min_zoom,
			max_zoom
		)
		zoom.y = zoom.x

func _input(event):
	if event.is_action_pressed("zoom_in") || event.is_action_pressed("zoom_out"):
		_update_desired_zoom()
	elif Input.is_action_pressed("pan") && event is InputEventMouseMotion:
		_update_pan(event)
		
func _update_desired_zoom():
	if Input.get_axis("zoom_in", "zoom_out") > 0:
		desired_zoom *= 1 + zoom_step
		desired_zoom = clamp(desired_zoom, min_zoom, max_zoom)
	else:
		desired_zoom *= 1 - zoom_step
		desired_zoom = clamp(desired_zoom, min_zoom, max_zoom)

func _update_pan(event):
	offset -= event.relative.rotated(global_rotation) / zoom.x
	offset.x = clamp(offset.x, -1000, 1000)
	offset.y = clamp(offset.y, -750, 750)
