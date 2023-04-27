extends HBoxContainer

var index: = 0
var data

@onready var hamster_profile = $HamsterProfile

# Called when the node enters the scene tree for the first time.
func _ready():
	data = HamsterData.hamsters[index]
	set_hamster_profile(data)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_left_button_pressed():
	AudioManager.play_btn()
	index = (index - 1) % HamsterData.hamsters.size()
	data = HamsterData.hamsters[index]
	set_hamster_profile(data)


func _on_right_button_pressed():
	AudioManager.play_btn()
	index = (index + 1) % HamsterData.hamsters.size()
	data = HamsterData.hamsters[index]
	set_hamster_profile(data)


func set_hamster_profile(data):
	hamster_profile.texture = data.profile
