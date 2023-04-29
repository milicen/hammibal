extends Node


var network = ENetMultiplayerPeer.new()
var port = 9898
var max_players = 100

@export var map_width: float
@export var map_height: float

@onready var player = preload("res://Scenes/Instances/player.tscn")
@onready var toy_ball = preload("res://Scenes/Instances/object/toy_ball.tscn")

#var players = {}

func _ready():
	start_server()

func start_server():
	network.create_server(port, max_players)
	multiplayer.multiplayer_peer = network
	print('Server started')
	multiplayer.peer_connected.connect(_on_PeerConnected)
	multiplayer.peer_disconnected.connect(_on_PeerDisconnected)
	
	await get_tree().process_frame
	spawn_toy_balls(1)
	

func _on_PeerConnected(player_id):
	print('Player %s connected' % str(player_id))
	pass

func _on_PeerDisconnected(player_id):
	print('Player %s disconnected' % str(player_id))
	if get_node('/root/Main/%s' % str(player_id)):
		get_node('/root/Main/%s' % str(player_id)).queue_free()
	
	pass

func spawn_toy_balls(num_of_ball: int):
	for n in num_of_ball:
		var ball = toy_ball.instantiate()
		var rand_x = randf_range(Game.MAP_POS.x, Game.MAP_SIZE.x)
		var rand_y = randf_range(Game.MAP_POS.y, Game.MAP_SIZE.y)
		var pos = Vector2(rand_x, rand_y)
		ball.global_position = pos
		get_node("/root/Main").add_child(ball, true)

@rpc("any_peer")
func disconnect_from_server(peer_id):
	network.disconnect_peer(peer_id)

@rpc("any_peer")
func add_player(id, data):
	var p = player.instantiate()
	p.name = str(id)
	p.username = data.username
	p.hamster_index = data.hamster_index
	get_node("/root/Main").add_child(p)
	print(p.username)
	print(p.hamster_index)
	rpc('add_player', id, data)

