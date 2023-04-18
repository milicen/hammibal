extends Node


var network = ENetMultiplayerPeer.new()
var port = 9898
var max_players = 100

@onready var player = preload("res://Scenes/Instances/player.tscn")

func _ready():
	start_server()

func start_server():
	network.create_server(port, max_players)
	multiplayer.multiplayer_peer = network
	print('Server started')
	multiplayer.peer_connected.connect(_on_PeerConnected)
	multiplayer.peer_disconnected.connect(_on_PeerDisconnected)
	

func _on_PeerConnected(player_id):
	print('Player %s connected' % str(player_id))
	pass

func _on_PeerDisconnected(player_id):
	print('Player %s disconnected' % str(player_id))
	get_node('/root/Main/%s' % str(player_id)).queue_free()
	
	pass

@rpc("any_peer")
func add_player(id):
	var p = player.instantiate()
	p.name = str(id)
	get_node("/root/Main").add_child(p)
	rpc('add_player', id)

@rpc("any_peer")
func process_existing_consumables(id):
	var consumables = get_tree().get_nodes_in_group('consumable')
	var arr = []
	for c in consumables:
		var data = {
			'name': c.name,
			'position': c.global_position,
			'rotation': c.rotation,
			'scale': c.scale
		}
		arr.append(data)
	rpc_id(id, 'add_existing_consumables', arr)
	pass

# client calls
@rpc("any_peer")
func add_existing_consumables(consumables): pass
