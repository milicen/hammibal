extends CanvasLayer


#@onready var player_info = $%PlayerInfo
@onready var hamster_select = $CenterContainer/VBoxContainer/GameInfoContainer/PlayerInfo/MarginContainer/VBoxContainer/HamsterSelect
@onready var input_name = $CenterContainer/VBoxContainer/GameInfoContainer/PlayerInfo/MarginContainer/VBoxContainer/Inputs/TextInput/HBoxContainer/PlayerNameInput
@onready var game_mode_info = $%GameModeInfo
@onready var team_container = $%TeamContainer

var loaded = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var main = preload("res://scenes/main.tscn").instantiate()
	var end_game_panel = preload('res://scenes/end_game/end_game_panel.tscn').instantiate()
	get_node('/root').call_deferred('add_child', main)
	get_node('/root').call_deferred('add_child', end_game_panel)
#	Server.connect_to_server()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_team_data():
	team_container.set_team()


func _on_game_mode_info_select_mode(mode):
	if !loaded:
		await self.ready
		loaded = true
	
	match mode:
		'solo':
			team_container.play(true)
		'team':
			team_container.play()


func _on_inputs_join_game():
#	PlayerData.username = input_name.text
#	PlayerData.chosen_hamster_index = hamster_select.index
#	get_tree().change_scene_to_file("res://scenes/main.tscn")
	if PlayerData.username == null: return
	self.hide()
	var player_data = {
		'username': PlayerData.username,
		'hamster_index': PlayerData.chosen_hamster_index
	}
	Server.rpc_id(1, 'add_player', multiplayer.get_unique_id(), player_data)
#	Server.connect_to_server()







