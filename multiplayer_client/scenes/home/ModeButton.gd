extends TextureButton


func play(reversed:= false):
	if reversed:
		$AnimationPlayer.play_backwards("toggle")
	else:
		$AnimationPlayer.play('toggle')
