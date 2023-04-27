extends CanvasLayer

@onready var profile = $ColorRect/EndGameInfo/MarginContainer/VBoxContainer/HamsterProfile 

func _ready():
	profile.texture = HamsterData.hamsters[PlayerData.chosen_hamster_index].hamster_ghost


func _on_return_home_button_pressed():
	AudioManager.play_btn()
	Server.disconnect_from_server(multiplayer.get_unique_id())
	get_tree().change_scene_to_file("res://scenes/home/home.tscn")
	self.queue_free()
