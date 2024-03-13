extends PanelContainer

@onready var throttle_label = %Throttle
@onready var force_label = %Force
@onready var brake_label = %Brake
@onready var velocity_label = %Velocity
@onready var mass_label = %Mass
@onready var friction_label = %Friction
@onready var drag_label = %Drag

func update_info(info):
	throttle_label.text = "%0.1f%%" % (info["throttle"]*100)
	force_label.text = "%d/%d (%0.1f%%)" % [round(info["force_applied"]), info["force_max"], (info["force_applied"]/info["force_max"])*100]
	brake_label.text = "%0.1f%%" % (info["brake"]*100)
	velocity_label.text = "%0.1f" % (0 if abs(info["velocity"]) < 0.1 else info["velocity"])
	mass_label.text = "%0.1f" % info["total_mass"]
	friction_label.text = "%0.1f" % info["friction"]
	drag_label.text = "%0.1f" % info["drag"]
