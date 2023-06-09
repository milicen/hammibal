extends TextureRect

@export var team_option_buttons: Control
@export var team_code_info: Control
@export var team_profile_container: Control

func play(reversed:= false):
	if reversed:
		$AnimationPlayer.play_backwards("toggle")
		hide_team_code()
	else:
		$AnimationPlayer.play("toggle")

func set_team():
	var profiles = team_profile_container.get_children()
	for i in Game.team_members.size():
		profiles[i].set_data(Game.team_members[i])
	
	for i in profiles.size():
		if i < Game.team_members.size():
			profiles[i].set_data(Game.team_members[i])
		else:
			profiles[i].set_data(null)


func _on_create_team_button_pressed():
	AudioManager.play_btn()
	Game.request_create_team()
	await Game.create_team_completed
	if Game.create_team_status == false:
		print_debug('failed to create team')
	else:
		print_debug('joined a team')
		show_team_code()
	
	pass # Replace with function body.


func _on_join_team_button_pressed():
	AudioManager.play_btn()
	$%JoinTeamPopup.show()
	pass # Replace with function body.

func show_team_code():
	team_code_info.get_child(0).text = PlayerData.team
	team_option_buttons.hide()
	team_code_info.show()

func hide_team_code():
	Game.request_update_player_data('team', null, multiplayer.get_unique_id())
	var profiles = team_profile_container.get_children()
	for child in profiles:
		child.set_data(null)
	team_code_info.hide()
	team_option_buttons.show()

