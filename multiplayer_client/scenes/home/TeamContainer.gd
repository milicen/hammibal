extends TextureRect


func play(reversed:= false):
	if reversed:
		$AnimationPlayer.play_backwards("toggle")
	else:
		$AnimationPlayer.play("toggle")


func _on_create_team_button_pressed():
	AudioManager.play_btn()
	pass # Replace with function body.


func _on_join_team_button_pressed():
	AudioManager.play_btn()
	$%JoinTeamPopup.show()
	pass # Replace with function body.
