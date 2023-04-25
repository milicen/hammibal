extends Node

var network = ENetMultiplayerPeer.new()
var port = 9898
var host = 'localhost'

var player = preload("res://scenes/hamster/hamster.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
#	connect_to_server()
	pass # Replace with function body.


func connect_to_server():
	
	
	network.create_client(host, port)
	multiplayer.multiplayer_peer = network
	
	multiplayer.connected_to_server.connect(
		func():
			print('connected to server ')
			rpc_id(1, 'add_player', multiplayer.get_unique_id())
			request_existing_consumables(multiplayer.get_unique_id())
			request_existing_toy_ball(multiplayer.get_unique_id())
	)
	
	multiplayer.server_disconnected.connect(
		func():
			print('disconnected from server')
			
	)

@rpc("any_peer")
func disconnect_from_server(peer_id):
	rpc_id(1, 'disconnect_from_server', peer_id)
	pass
#	network.disconnect_peer(multiplayer.get_unique_id())


@rpc("any_peer")
func add_player(id):
	if multiplayer.get_unique_id() != id and !get_node("/root/Main/%s" % str(id)):
		var p = player.instantiate()
		p.name = str(id)
		get_node("/root/Main").add_child(p)

func request_existing_consumables(id):
	rpc_id(1, 'process_existing_consumables', id)

@rpc("any_peer")
func add_existing_consumables(consumables):
	for num in consumables.size():
		print(consumables[num])
		Game.instance_consumable(consumables[num])
	

func request_existing_toy_ball(id):
	rpc_id(1, 'process_existing_toy_ball', id)


@rpc("any_peer")
func add_existing_toy_ball(toy_ball_arr):
	for data in toy_ball_arr:
		Game.instance_toy_ball(data)

# server calls
@rpc("any_peer")
func process_existing_consumables(id): pass

@rpc("any_peer")
func process_existing_toy_ball(id): pass
