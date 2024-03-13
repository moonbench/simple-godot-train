extends Node

func exit():
	get_tree().get_root().propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit.call_deferred()

func switch_to_scene(new_scene_path: String):
	get_tree().change_scene_to_packed(load(new_scene_path))
