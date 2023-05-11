extends Node

var consumables = {
	'poop': preload("res://Scenes/Instances/consumable/poop.tscn"),
	'sun_seed': preload("res://Scenes/Instances/consumable/sun_seed.tscn"),
	'pumpkin_seed': preload("res://Scenes/Instances/consumable/pumpkin_seed.tscn"),
	'carrot': preload("res://Scenes/Instances/consumable/carrot.tscn"),
	'corn_a': preload("res://Scenes/Instances/consumable/corn_a.tscn"),
	'corn_b': preload("res://Scenes/Instances/consumable/corn_b.tscn"),
	'pomo_a': preload("res://Scenes/Instances/consumable/pomo_a.tscn"),
	'pomo_b': preload("res://Scenes/Instances/consumable/pomo_b.tscn"),
	'fetus': preload("res://Scenes/Instances/consumable/fetus.tscn"),
	'lettuce': preload("res://Scenes/Instances/consumable/lettuce.tscn"),
}


const MAP_POS = Vector2(-2077,-1563)
const MAP_SIZE = Vector2(5307+MAP_POS.x,3774+MAP_POS.y) 
const PLAYER_BASE_SIZE = 70.0

var players := []

#client porject calls
@rpc("any_peer")
func receive_poop_attack(consumable_name, requester_id): pass

@rpc("any_peer")
func receive_spit_nut(consumable_name, requester_id): pass

@rpc("any_peer")
func receive_hunt_hamster(hunter, prey): 	pass

@rpc("any_peer")
func receive_kill_hamster(hamster_name): pass

@rpc("any_peer","call_local")
func move_toy_ball(ball_name, force): 
	var ball = get_node("/root/Main/%s" % str(ball_name))
	ball.force = force


func spawn_consumable():
	var dupe = consumables.duplicate(true)
	dupe.erase('poop')
	
	var keys = dupe.keys()
	var key = keys[randi() % keys.size()]
	var consumable = dupe[key].instantiate()
	
	var rand_size = randf_range(0.4, 0.6)
	var rand_rotation = randf_range(0, 2*PI)
	var rand_x = randf_range(MAP_POS.x, MAP_SIZE.x)
	var rand_y = randf_range(MAP_POS.y, MAP_SIZE.y)
	var pos = Vector2(rand_x, rand_y)
	
	consumable.init(-1, pos, Vector2.ZERO, rand_size, rand_rotation)
	get_node("/root/Main").add_child(consumable, true)
	
	var _name: String = consumable.name
	var mod = _name.rstrip('1234567890')



# realtime sb functions `players`
@rpc("any_peer")
func get_in_game_players(requester_id):
	var in_game_players = players.filter(\
		func(player):
			return player.in_game == true
	)
	in_game_players.sort_custom(sort_simple)
	rpc_id(requester_id, 'receive_in_game_players', in_game_players)
	

func sort_simple(a,b):
	var player_a = get_node_or_null("/root/Main/%s" % str(a.id))
	var player_b = get_node_or_null("/root/Main/%s" % str(b.id))
	
	
	if !player_a or !player_b: return
	
	return player_a.mass > player_b.mass


@rpc
func receive_in_game_players(players): pass

@rpc("any_peer")
func process_update_player_data(column, value, id):
	var updated_player = await Queries.update_player(id, {column: value})
#	print('req update player: ', updated_player)
	rpc_id(id, 'receive_update_player_data', updated_player[0])
	pass

@rpc
func receive_update_player_data(new_data):
	pass

func add_player_data(new_record):
	players.append(new_record)
	send_latest_players()

func update_player_data(id, new_record):
	for index in players.size():
		if players[index].id == id: 
			players[index] = new_record
			break
	send_latest_players()


func delete_player_data(id):
	var index
	for i in players.size():
		if players[i].id != id: continue
		index = i
		break

	players.erase(players[index])
	send_latest_players()


func send_latest_players():
	rpc('get_latest_players', players)

@rpc
func get_latest_players(players): pass


# realtime sb function `teams`
@rpc("any_peer")
func process_join_team(code, id):
	var team = await Queries.get_team(code)
	if team.size() < 1:
		rpc_id(id, 'receive_join_team',null, false, 'Team not found')
	else:
		var players_in_team = players.filter(func(player): return player.team == team[0].code)
		if players_in_team.size() >= 5:
			rpc_id(id, 'receive_join_team', null, false, 'Team is full')
		else:
			var update_player = await Queries.update_player(id, {'team': team[0].code})
			rpc_id(id, 'receive_join_team', team[0].code, true, 'Successfully joined team')

@rpc
func receive_join_team(success: bool): pass

@rpc('any_peer')
func process_create_team(id):
	var team = await Queries.insert_new_team()
	if team.size() < 1:
		rpc_id(id, 'receive_create_team', null, false)
	else:
		var update_player = await Queries.update_player(id, {'team': team[0].code})
		rpc_id(id, 'receive_create_team', team[0].code, true)


@rpc
func receive_create_team(code, success: bool): pass


# server project calls
func get_player_pos():
#	if player_node == null: return
#	var player_nodes = get_tree().get_nodes_in_group('player')
	
	var rand_x = randf_range(MAP_POS.x + 200, MAP_SIZE.x - 200)
	var rand_y = randf_range(MAP_POS.y + 200, MAP_SIZE.y - 200)
	var pos = Vector2(rand_x, rand_y)
	print_debug('gen pos: ', pos)
	
	return pos
	

@rpc("any_peer")
func free_hamster(id):
	get_node("/root/Main/%s" % str(id)).queue_free()

@rpc("any_peer")
func process_poop_attack(position, direction, requester_id): 
	var p = consumables['poop'].instantiate()
	var rand_size = randf_range(0.4, 0.6)
	var rand_rotation = randf_range(0, 2*PI)
	p.init(requester_id, position, direction, rand_size, rand_rotation)
	get_node("/root/Main").add_child(p, true)
	rpc('receive_poop_attack', p.name, requester_id)

@rpc("any_peer")
func process_spit_nut(position, direction, requester_id):
	var rand = randi() % 2
	var nut = consumables['sun_seed'].instantiate() if rand == 0 else consumables['pumpkin_seed'].instantiate()
	var rand_size = randf_range(0.4, 0.6)
	var rand_rotation = randf_range(0, 2*PI)
	nut.init(requester_id, position, direction, rand_size, rand_rotation)
	get_node('/root/Main').add_child(nut, true)
	rpc('receive_spit_nut', nut.name, requester_id)

@rpc("any_peer")
func process_despawn_pickup(pickup_name, requester_id):
	var pickup = get_node_or_null("/root/Main/%s" % str(pickup_name))
	if pickup:
		pickup.call_deferred('queue_free')


@rpc("any_peer")
func process_hunt_hamster(hunter, prey):
	var p_hamster = get_node_or_null("/root/Main/%s" % str(prey))
#	if p_hamster:
#		p_hamster.call_deferred('queue_free')
	var update_player_data = {
		'in_game': false
	}
	await Queries.update_player(prey, update_player_data)
	rpc('receive_hunt_hamster', hunter , prey)

@rpc("any_peer")
func process_kill_hamster(hamster_name):
	var hamster = get_node("/root/Main/%s" % str(hamster_name))
#	hamster.call_deferred('queue_free')
	var update_player_data = {
		'in_game': false
	}
	await Queries.update_player(hamster_name, update_player_data)
	rpc('receive_kill_hamster', hamster_name)












