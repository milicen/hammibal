extends CanvasLayer


@onready var player_info = $%PlayerInfo
@onready var game_mode_info = $%GameModeInfo
@onready var team_container = $%TeamContainer

var loaded = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_game_mode_info_select_mode(mode):
	if !loaded:
		await self.ready
		loaded = true
	
	match mode:
		'solo':
			team_container.play(true)
		'team':
			team_container.play()


func _on_inputs_join_game(host_type):
	get_tree().change_scene_to_file("res://scenes/main.tscn")
#	Server.connect_to_server()




