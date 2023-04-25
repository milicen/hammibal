extends TextureRect

signal select_mode(mode: String)

var game_mode: String:
	get: 
		return game_mode
	set(value):
		if game_mode == value: return
		
		var last_mode = game_mode
		game_mode = value
		
		emit_signal('select_mode', game_mode)
		
		match game_mode:
			'solo':
				solo_btn.play()
				if last_mode == '': return
				team_btn.play(true)
			'team':
				team_btn.play()
				if last_mode == '': return
				solo_btn.play(true)


@onready var solo_btn = $MarginContainer/VBoxContainer/Modes/SoloButton
@onready var team_btn = $MarginContainer/VBoxContainer/Modes/TeamButton

func _ready():
	game_mode = 'solo'

func _on_solo_button_pressed():
	game_mode = 'solo'

func _on_team_button_pressed():
	game_mode = 'team'
