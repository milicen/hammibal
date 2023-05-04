extends CanvasLayer

@onready var profile = $ColorRect/EndGameInfo/MarginContainer/VBoxContainer/HamsterProfile 

func _ready():
	hide()
	profile.texture = HamsterData.hamsters[PlayerData.chosen_hamster_index].hamster_ghost


func _on_return_home_button_pressed():
	AudioManager.play_btn()
#	Server.disconnect_from_server(multiplayer.get_unique_id())
#	get_tree().change_scene_to_file("res://scenes/home/home.tscn")
	get_node("/root/Home").show()
	get_node("/root/Main").hide_hud()
	Game.free_hamster(multiplayer.get_unique_id())
#	get_node("/root/Main/%s" % str(multiplayer.get_unique_id())).call_deferred('queue_free')
	hide()
#	self.call_deferred('queue_free')

func show_panel():
	show()
	profile.texture = HamsterData.hamsters[PlayerData.chosen_hamster_index].hamster_ghost

	
