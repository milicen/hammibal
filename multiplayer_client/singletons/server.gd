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
			var player_data = {
				'username': PlayerData.username,
				'hamster_index': PlayerData.chosen_hamster_index
			}
			rpc_id(1, 'add_player', multiplayer.get_unique_id(), player_data)
	)
	
	multiplayer.server_disconnected.connect(
		func():
			print('disconnected from server')
			
	)

@rpc("any_peer")
func disconnect_from_server(peer_id):
	rpc_id(1, 'disconnect_from_server', peer_id)


@rpc("any_peer")
func add_player(id, data):
	var p = get_node_or_null("/root/Main/%s" % str(id))
	print_debug(data)
	if p:
		p.set_hamster(data.username, data.hamster_index)
		
	if multiplayer.get_unique_id() == id:
		
		p.connect('poop_count_changed', get_node("/root/Main/HUD").on_Player_poop_count_changed)
		p.connect('nut_count_changed', get_node("/root/Main/HUD").on_Player_nut_count_changed)


