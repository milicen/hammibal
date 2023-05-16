extends Node


var network = ENetMultiplayerPeer.new()
var port = 9898
var max_players = 100

@export var map_width: float
@export var map_height: float

@onready var player = preload("res://Scenes/Instances/player.tscn")
@onready var toy_ball = preload("res://Scenes/Instances/object/toy_ball.tscn")

#var players = {}
var sb_client: RealtimeClient

func _ready():
	connect_to_realtime_sb()
	start_server()

func connect_to_realtime_sb():
	await Supabase.ready
	sb_client = Supabase.realtime.client()
	sb_client.connect('disconnected', func(): create_realtime_connection())
	create_realtime_connection()
#	sb_client.connect_client()
#	await sb_client.connected
#	var channel = sb_client\
#					.channel('public', 'players')\
#					.on('all', on_sb_channel_update)\
#					.subscribe()

func create_realtime_connection():
	sb_client.connect_client()
	await sb_client.connected
	var channel = sb_client\
					.channel('public', 'players')\
					.on('all', on_sb_channel_update)\
					.subscribe()

func on_sb_channel_update(old_record: Dictionary, new_record: Dictionary, channel):
#	print('realtime update')
	# insert operation
	if old_record.is_empty() and !new_record.is_empty():
		Game.add_player_data(new_record)
		pass
	
	# update operation
	if !old_record.is_empty() and !new_record.is_empty():
		Game.update_player_data(old_record.id, new_record)
		pass

	# delete operation
	if !old_record.is_empty() and new_record.is_empty():
		print('delete id: ', old_record.id)
		Game.delete_player_data(old_record.id)
		pass


func start_server():
	network.create_server(port, max_players)
	multiplayer.multiplayer_peer = network
	print('Server started')
	multiplayer.peer_connected.connect(_on_PeerConnected)
	multiplayer.peer_disconnected.connect(_on_PeerDisconnected)
	
	await get_tree().process_frame
	spawn_toy_balls(4)
	

func _on_PeerConnected(player_id):
	print('Player %s connected' % str(player_id))
	var new_player = {
		'id': player_id
	}
	
	await Queries.insert_new_player(new_player)


func _on_PeerDisconnected(player_id):
	print('Player %s disconnected' % str(player_id))
	if get_node('/root/Main/%s' % str(player_id)):
		get_node('/root/Main/%s' % str(player_id)).queue_free()
	
	await Queries.delete_player(player_id)


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
	var update_player_data = {
		'in_game': true
	}
	await Queries.update_player(id, update_player_data)
	var p = player.instantiate()
	p.name = str(id)
	p.username = data.username
	p.hamster_index = data.hamster_index
#	Game.set_player_pos(p)
	get_node("/root/Main").add_child(p)
#	print(p.username)
#	print(p.hamster_index)
	rpc('add_player', id, data)

