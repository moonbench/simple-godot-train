extends Node

func exit():
	get_tree().get_root().propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit.call_deferred()

func switch_to_scene(new_scene_path: String):
	UI.transitions.swipe_on()
	
	var delay = create_tween()
	delay.tween_callback(func(): get_tree().change_scene_to_packed(load(new_scene_path))).set_delay(0.6)
	delay.tween_callback(UI.transitions.swipe_off).set_delay(0.2)
