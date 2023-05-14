extends Node

var network = ENetMultiplayerPeer.new()
var port = 9898
var host = 'localhost'
#var host = '192.168.63.146'

var player = preload("res://scenes/hamster/hamster.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
#	await Supabase.ready
#	var sb_client = Supabase.realtime.client()
#	sb_client.connect_client()
#	await sb_client.connected
#	var channel = sb_client\
#					.channel('public', 'players')\
#					.on('all', on_sb_channel_update)\
#					.subscribe()
	
	connect_to_server()


#func _notification(what):
#	if what == NOTIFICATION_WM_CLOSE_REQUEST:
#		await Queries.delete_player(multiplayer.get_unique_id())
#		get_tree().quit()

#func on_sb_channel_update(old_record: Dictionary, new_record: Dictionary, channel):
#	print('realtime update')
#	# insert operation
#	if old_record.is_empty() and !new_record.is_empty():
#		Game.add_player_data(new_record)
#		pass
#
#	# update operation
#	if !old_record.is_empty() and !new_record.is_empty():
#		Game.update_player_data(old_record.id, new_record)
#		pass
#
#	# delete operation
#	if !old_record.is_empty() and new_record.is_empty():
#		Game.delete_player_data(old_record.id)
#		pass

func connect_to_server():
	network.create_client(host, port)
	multiplayer.multiplayer_peer = network
	
	multiplayer.connected_to_server.connect(
		func():
			print('connected to server ')
#			var new_player = {
#				'id': multiplayer.get_unique_id()
#			}
#
#			await Queries.insert_new_player(new_player)

	)
	
	multiplayer.server_disconnected.connect(
		func():
			print('disconnected from server')
			
	)

@rpc("any_peer")
func disconnect_from_server(peer_id):
#	await Queries.update_player(peer_id, {'in_game': false})
	rpc_id(1, 'disconnect_from_server', peer_id)


@rpc("any_peer")
func add_player(id, data):
	var p = get_node_or_null("/root/Main/%s" % str(id))
#	print_debug(data)
	if p:
		p.set_hamster(data.username, data.hamster_index)
		
	if multiplayer.get_unique_id() == id:
		p.connect('poop_count_changed', get_node("/root/Main/HUD").on_Player_poop_count_changed)
		p.connect('nut_count_changed', get_node("/root/Main/HUD").on_Player_nut_count_changed)
		get_node('/root/Main').show_hud()

#	var update_player_data = {
#		'in_game': true
#	}
#	await Queries.update_player(id, update_player_data)


#func remove_player_from_db(id):
#	var query = SupabaseQuery.new().from('players').delete().Is('id', id)
#	var result = await Supabase.database.query(query).completed
#	print_debug('delete res: ', result.data)
