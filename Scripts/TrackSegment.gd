tool

extends Path2D

signal wheel_at_head
signal wheel_at_tail

class_name Track

func _ready():
	_update_sprites_for_curve()

func _update_sprites_for_curve():
	$HeadPoint.unit_offset = 0
	$TailPoint.unit_offset = 1
	$HeadPoint/Sprite.global_rotation = 0
	$TailPoint/Sprite.global_rotation = 0
	$Line2D.points = curve.get_baked_points()

func enter_from_head(wheel: PathFollow2D, extra, is_forward):
	wheel.set_rail(self)
	wheel.offset = extra
	wheel.head_to_tail() if is_forward else wheel.tail_to_head()

func enter_from_tail(wheel: PathFollow2D, extra, is_forward):
	wheel.set_rail(self)
	wheel.unit_offset = 1
	wheel.offset -= extra
	wheel.tail_to_head() if is_forward else wheel.head_to_tail()

func wheel_at_head(wheel, extra, is_forward):
	emit_signal("wheel_at_head", wheel, extra, is_forward)

func wheel_at_tail(wheel, extra, is_forward):
	emit_signal("wheel_at_tail", wheel, extra, is_forward)

func link_track(other_track, from_side, to_side):
	connect("wheel_at_" + from_side, other_track, "enter_from_" + to_side)
	other_track.connect("wheel_at_" + to_side, self, "enter_from_" + from_side)
