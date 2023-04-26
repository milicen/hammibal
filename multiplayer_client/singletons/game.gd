extends Node


var poop_scene = preload("res://scenes/consumables/poop.tscn")
var sun_seed_scene = preload("res://scenes/consumables/sun_seed.tscn")
var pumpkin_seed_scene = preload("res://scenes/consumables/pumpkin_seed.tscn")

var consumables = {
	'poop': preload("res://scenes/consumables/poop.tscn"),
	'sun_seed': preload("res://scenes/consumables/sun_seed.tscn"),
	'pumpkin_seed': preload("res://scenes/consumables/pumpkin_seed.tscn"),
	'carrot': preload("res://scenes/consumables/carrot.tscn"),
	'corn_a': preload("res://scenes/consumables/corn_a.tscn"),
	'corn_b': preload("res://scenes/consumables/corn_b.tscn"),
	'pomo_a': preload("res://scenes/consumables/pomo_a.tscn"),
	'pomo_b': preload("res://scenes/consumables/pomo_b.tscn"),
	'fetus': preload("res://scenes/consumables/fetus.tscn"),
	'lettuce': preload("res://scenes/consumables/lettuce.tscn"),
}

var toy_ball = preload("res://scenes/objects/toy_ball.tscn")
var end_game_panel = preload("res://scenes/end_game/end_game_panel.tscn")

func is_main_null():
	return get_node_or_null("/root/Main") == null

func instance_consumable(data: Dictionary):
	var c_name = str(data.name).to_snake_case()
	if c_name.contains('poop'):
		var poop:Consumable = poop_scene.instantiate()
		poop.name = str(data.name)
		poop.scale = data.scale
		poop.position = data.position
		poop.rotation = data.rotation
		poop.mass = data.mass
		if is_main_null(): return
		get_node_or_null("/root/Main").add_child(poop)
	
	if c_name.contains('sun'):
		var sun_seed:Consumable = sun_seed_scene.instantiate()
		sun_seed.name = str(data.name)
		sun_seed.scale = data.scale
		sun_seed.position = data.position
		sun_seed.rotation = data.rotation
		sun_seed.mass = data.mass
		if is_main_null(): return
		get_node_or_null("/root/Main").add_child(sun_seed)
	
	if c_name.contains('pumpkin'):
		var pumpkin_seed:Consumable = pumpkin_seed_scene.instantiate()
		pumpkin_seed.name = str(data.name)
		pumpkin_seed.scale = data.scale
		pumpkin_seed.position = data.position
		pumpkin_seed.rotation = data.rotation
		pumpkin_seed.mass = data.mass
		if is_main_null(): return
		get_node_or_null("/root/Main").add_child(pumpkin_seed)

func instance_toy_ball(data: Dictionary):
	var tb = toy_ball.instantiate()
	tb.name = data.name
	tb.global_position = data.position
	tb.rotation = data.rotation
	if is_main_null(): return
	get_node_or_null("/root/Main").add_child(tb)

@rpc("any_peer","call_local")
func move_toy_ball(ball_name, force):
	var ball = get_node("/root/Main/%s" % str(ball_name))
	ball.force = force
#	ball.set_velocity(force)

@rpc("any_peer")
func spawn_consumable(pos, size, rot, con_name, type):
	var consumable = consumables[type].instantiate()
	consumable.init(-1, pos, Vector2.ZERO, size, rot)
	consumable.name = con_name
	if is_main_null(): return
	get_node_or_null("/root/Main").add_child(consumable)

func request_poop_attack(position, direction, requester_id):
	rpc_id(1, 'process_poop_attack', position, direction, requester_id)

@rpc("any_peer")
func receive_poop_attack(position, direction, size, rotation, consumable_name, requester_id):
	var poop:Consumable = poop_scene.instantiate()
	poop.init(requester_id, position, direction, size, rotation)
#	poop.set_multiplayer_authority(requester_id)
#	print('poop is ability: ', poop.is_ability)
	poop.name = consumable_name
	if is_main_null(): return
	get_node_or_null("/root/Main").add_child(poop)
	
	var requester = get_node("/root/Main/%s" % str(requester_id))
	requester.calculate_mass_release(poop)

func request_spit_nut(position, direction, requester_id):
	rpc_id(1, 'process_spit_nut', position, direction, requester_id)

@rpc("any_peer")
func receive_spit_nut(position, direction, size, rotation, consumable_name, requester_id):
	var lc_name = str(consumable_name).to_snake_case()
	var nut = sun_seed_scene.instantiate() if lc_name.contains('sun') else pumpkin_seed_scene.instantiate()
	nut.init(requester_id, position, direction, size, rotation)
#	nut.set_multiplayer_authority(requester_id)
	nut.name = consumable_name
	if is_main_null(): return
	get_node('/root/Main').add_child(nut)
	
	var requester = get_node("/root/Main/%s" % str(requester_id))
	requester.calculate_mass_release(nut)

func request_despawn_pickup(pickup_name, requester_id):
	rpc_id(1, 'process_despawn_pickup', pickup_name, requester_id)

@rpc("any_peer")
func receive_despawn_pickup(pickup_name, requester_id):
	var pickup: Consumable = get_node_or_null('/root/Main/%s' % str(pickup_name))
	var requester = get_node('/root/Main/%s' % str(requester_id))
	requester.calculate_mass_eat(pickup)
	pickup.despawn()
		

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
		var panel = end_game_panel.instantiate()
		get_node("/root").add_child(panel)
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
		var panel = end_game_panel.instantiate()
		get_node("/root").add_child(panel)
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
