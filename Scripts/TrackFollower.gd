extends PathFollow2D

enum RAIL_DIRECTION {HEADWARD, TAILWARD}
var rail_direction = RAIL_DIRECTION.TAILWARD

var follow_distance

signal at_rail_head
signal at_rail_tail
signal moved

var current_rail
var current_rail_length

onready var sprite = $Sprite

func place_follower(follower, distance):
	follower.follow_distance = distance
	follower.rail_direction = rail_direction
	follower.set_rail(current_rail)
	follower.offset = offset
	follower.move(-distance)

func move(distance):
	var original_offset = offset
	_move_in_current_direction(distance)
	_change_rail_if_end(original_offset, distance)
	emit_signal("moved", distance, offset, rail_direction, current_rail, current_rail_length)

func _move_in_current_direction(distance):
	offset += distance if rail_direction == RAIL_DIRECTION.TAILWARD else -distance

func move_as_follower(distance, leader_offset, leader_direction, leader_rail, leader_rail_length):
	if leader_offset > follow_distance && leader_offset < leader_rail_length - follow_distance:
		if leader_rail != current_rail:
			put_on_leader_rail(leader_rail, leader_direction)
		set_at_distance_from_leader(distance, leader_offset, leader_direction)
	else:
		move(distance)

func put_on_leader_rail(leader_rail, leader_direction):
	if leader_rail != current_rail:
		set_rail(leader_rail)
		head_to_tail() if leader_direction == RAIL_DIRECTION.TAILWARD else tail_to_head()

func set_at_distance_from_leader(distance, leader_offset, leader_direction):
	var original_offset = offset
	offset = leader_offset + (-follow_distance if leader_direction == RAIL_DIRECTION.TAILWARD else follow_distance)
	_change_rail_if_end(original_offset, distance)
	emit_signal("moved", distance, offset, rail_direction, current_rail, current_rail_length)

func _change_rail_if_end(original_offset, distance_moved):
	if !current_rail: return
	if unit_offset <= 0:
		emit_signal("at_rail_head", self, abs(original_offset - abs(distance_moved)), distance_moved > 0)
	elif unit_offset >= 1:
		emit_signal("at_rail_tail", self, original_offset + abs(distance_moved) - current_rail_length, distance_moved > 0)

func unset_rail():
	if current_rail:
		disconnect("at_rail_head", current_rail, "wheel_at_head")
		disconnect("at_rail_tail", current_rail, "wheel_at_tail")
		current_rail = null
		current_rail_length = null

func set_rail(rail: Path2D):
	get_parent().remove_child(self)
	unset_rail()
	current_rail = rail
	current_rail_length = rail.curve.get_baked_length()
	rail.add_child(self)
	connect("at_rail_head", rail, "wheel_at_head")
	connect("at_rail_tail", rail, "wheel_at_tail")

func head_to_tail():
	rail_direction = RAIL_DIRECTION.TAILWARD
	sprite.flip_v = false

func tail_to_head():
	rail_direction = RAIL_DIRECTION.HEADWARD
	sprite.flip_v = true
