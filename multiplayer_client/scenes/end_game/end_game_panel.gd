extends CanvasLayer




func _on_return_home_button_pressed():
	print('pressed')
	Server.disconnect_from_server(multiplayer.get_unique_id())
	get_tree().change_scene_to_file("res://scenes/home/home.tscn")
	self.queue_free()
