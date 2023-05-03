extends Node


#var poop_scene = preload("res://scenes/consumables/poop.tscn")
#var sun_seed_scene = preload("res://scenes/consumables/sun_seed.tscn")
#var pumpkin_seed_scene = preload("res://scenes/consumables/pumpkin_seed.tscn")
#
#var consumables = {
#	'poop': preload("res://scenes/consumables/poop.tscn"),
#	'sun_seed': preload("res://scenes/consumables/sun_seed.tscn"),
#	'pumpkin_seed': preload("res://scenes/consumables/pumpkin_seed.tscn"),
#	'carrot': preload("res://scenes/consumables/carrot.tscn"),
#	'corn_a': preload("res://scenes/consumables/corn_a.tscn"),
#	'corn_b': preload("res://scenes/consumables/corn_b.tscn"),
#	'pomo_a': preload("res://scenes/consumables/pomo_a.tscn"),
#	'pomo_b': preload("res://scenes/consumables/pomo_b.tscn"),
#	'fetus': preload("res://scenes/consumables/fetus.tscn"),
#	'lettuce': preload("res://scenes/consumables/lettuce.tscn"),
#}

#var toy_ball = preload("res://scenes/objects/toy_ball.tscn")

var players := []
#	set(value):
#		players = value
#		print(players)
#		in_game_players = players.filter(\
#			func(player):
#				return player.in_game == true
#		)



var end_game_panel = preload("res://scenes/end_game/end_game_panel.tscn")

func get_in_game_players():
	print(players)
	var in_game_players = players.filter(\
		func(player):
			return player.in_game == true
	)
	return in_game_players

func add_player_data(new_record):
	players.append(new_record)
#	in_game_players = players.filter(\
#		func(player):
#			return player.in_game == true
#	)

func update_player_data(id, new_record):
	for index in players.size():
		if players[index].id == id: 
			players[index] = new_record
			break


func delete_player_data(id):
	var index
	for i in players.size():
		if players[i].id != id: continue
		index = i
		break

	players.erase(players[index])


@rpc("any_peer","call_local")
func move_toy_ball(ball_name, force):
	var ball = get_node("/root/Main/%s" % str(ball_name))
	ball.force = force
#	ball.set_velocity(force)


func request_poop_attack(position, direction, requester_id):
	rpc_id(1, 'process_poop_attack', position, direction, requester_id)

@rpc("any_peer")
func receive_poop_attack(consumable_name, requester_id):
	var poop = get_node("/root/Main/%s" % consumable_name)
	var requester = get_node("/root/Main/%s" % str(requester_id))
	requester.calculate_mass_release(poop)

func request_spit_nut(position, direction, requester_id):
	rpc_id(1, 'process_spit_nut', position, direction, requester_id)

@rpc("any_peer")
func receive_spit_nut(consumable_name, requester_id):
	var nut = get_node("/root/Main/%s" % consumable_name)
	var requester = get_node("/root/Main/%s" % str(requester_id))
	requester.calculate_mass_release(nut)

func request_despawn_pickup(pickup_name, requester_id):
	rpc_id(1, 'process_despawn_pickup', pickup_name, requester_id)


func request_hunt_hamster(hunter, prey):
	var p_hamster = get_node_or_null("/root/Main/%s" % str(prey))
	var h_hamster = get_node("/root/Main/%s" % str(hunter))
	h_hamster.add_mass(p_hamster.mass)
	rpc_id(1, 'process_hunt_hamster', hunter, prey)

@rpc("any_peer")
func receive_hunt_hamster(hunter, prey):
	var p_hamster = get_node_or_null("/root/Main/%s" % str(prey))
	p_hamster.freeze_hamster()
	
	if prey == multiplayer.get_unique_id():
#		get_tree().quit()
		await get_tree().create_timer(1.0).timeout
#		var panel = end_game_panel.instantiate()
#		get_node("/root").add_child(panel)
		get_node('/root/EndGamePanel').show()
		return


func request_kill_hamster(hamster_name):
	rpc_id(1, 'process_kill_hamster', hamster_name)

@rpc("any_peer")
func receive_kill_hamster(hamster_name):
	var hamster = get_node("/root/Main/%s" % str(hamster_name))
	hamster.freeze_hamster()
	
	if str(hamster_name).to_int() == multiplayer.get_unique_id():
#		get_tree().quit()
		await get_tree().create_timer(1.0).timeout
#		var panel = end_game_panel.instantiate()
#		get_node("/root").add_child(panel)
		get_node('/root/EndGamePanel').show()
		return
	
#	hamster.queue_free()
	
	

# server project calls
@rpc("any_peer")
func process_poop_attack(position, direction, requester_id): pass

@rpc("any_peer")
func process_spit_nut(position, direction, requester_id): pass

@rpc("any_peer")
func process_despawn_pickup(pickup_name, requester_id): pass

@rpc("any_peer")
func process_hunt_hamster(hunter, prey): pass

@rpc("any_peer")
func process_kill_hamster(hamster_name): pass
