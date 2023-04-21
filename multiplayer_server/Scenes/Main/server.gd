extends Node


var network = ENetMultiplayerPeer.new()
var port = 9898
var max_players = 100

@export var map_width: float
@export var map_height: float

@onready var player = preload("res://Scenes/Instances/player.tscn")
@onready var toy_ball = preload("res://Scenes/Instances/object/toy_ball.tscn")

func _ready():
	start_server()

func start_server():
	network.create_server(port, max_players)
	multiplayer.multiplayer_peer = network
	print('Server started')
	multiplayer.peer_connected.connect(_on_PeerConnected)
	multiplayer.peer_disconnected.connect(_on_PeerDisconnected)
	
	spawn_toy_balls(4)
	

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
		var rand_x = randf_range(0, map_width)
		var rand_y = randf_range(0, map_height)
		var pos = Vector2(rand_x, rand_y)
		get_node("/root/Main").add_child(ball, true)
		ball.global_position = pos

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
			'scale': c.scale,
			'mass': c.mass
		}
		arr.append(data)
	rpc_id(id, 'add_existing_consumables', arr)


@rpc("any_peer")
func process_existing_toy_ball(id):
	var toy_ball_arr = get_tree().get_nodes_in_group('toy_ball')
	var arr = []
	for toy_ball in toy_ball_arr:
		var data = {
			'name': toy_ball.name,
			'position': toy_ball.global_position,
			'rotation': toy_ball.rotation
		}
		arr.append(data)
	rpc_id(id, 'add_existing_toy_ball', arr)


# client calls
@rpc("any_peer")
func add_existing_consumables(consumables): pass

@rpc("any_peer")
func add_existing_toy_ball(toy_ball_arr): pass
