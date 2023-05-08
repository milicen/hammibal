extends Node


signal create_team_completed
signal join_team_completed
signal received_in_game_players

var join_team_status
var create_team_status

var players := []
var in_game_players := []

var end_game_panel = preload("res://scenes/end_game/end_game_panel.tscn")

# team db requests
func request_join_team(code):
	rpc_id(1, 'process_join_team', code, multiplayer.get_unique_id())

@rpc("any_peer")
func receive_join_team(code, success: bool):
	join_team_status = success
	if success: 
		PlayerData.team = code
	emit_signal('join_team_completed')

@rpc
func process_join_team(code, id): pass

func request_create_team():
	rpc_id(1, 'process_create_team', multiplayer.get_unique_id())

@rpc("any_peer")
func receive_create_team(code, success: bool):
	create_team_status = success
	if success:
		PlayerData.team = code
	emit_signal('create_team_completed')
	pass

@rpc
func process_create_team(id): pass

# player db requests
func request_in_game_players():
	rpc_id(1, 'get_in_game_players', multiplayer.get_unique_id())

@rpc("any_peer")
func receive_in_game_players(in_game_players):
	self.in_game_players = in_game_players
	emit_signal('received_in_game_players')

@rpc
func get_in_game_players(requester_id): pass

func request_update_player_data(column, value, id):
	rpc_id(1, 'process_update_player_data', column, value, id)

@rpc("any_peer")
func receive_update_player_data(new_data):
#	print('new data: ', new_data)
	PlayerData.username = new_data.username
	PlayerData.chosen_hamster_index = new_data.hamster_index
	PlayerData.team = new_data.team
	pass

@rpc
func process_update_player_data(column, value, id): pass



# game requests
@rpc("any_peer")
func free_hamster(id):
	rpc_id(1, 'free_hamster', id)

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
		await get_tree().create_timer(1.0).timeout
		get_node('/root/EndGamePanel').show_panel()
		return


func request_kill_hamster(hamster_name):
	rpc_id(1, 'process_kill_hamster', hamster_name)

@rpc("any_peer")
func receive_kill_hamster(hamster_name):
	var hamster = get_node("/root/Main/%s" % str(hamster_name))
	hamster.freeze_hamster()
	
	if str(hamster_name).to_int() == multiplayer.get_unique_id():
		await get_tree().create_timer(1.0).timeout
		get_node('/root/EndGamePanel').show_panel()
		return
	
	

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
