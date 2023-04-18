extends Node


var poop_scene = preload("res://scenes/consumables/poop.tscn")
var sun_seed_scene = preload("res://scenes/consumables/sun_seed.tscn")
var pumpkin_seed_scene = preload("res://scenes/consumables/pumpkin_seed.tscn")

func instance_consumable(data: Dictionary):
	var c_name = str(data.name).to_snake_case()
	if c_name.contains('poop'):
		var poop:Consumable = poop_scene.instantiate()
		poop.name = str(data.name)
		poop.scale = data.scale
		poop.position = data.position
		poop.rotation = data.rotation
		get_node("/root/Main").add_child(poop)
	
	if c_name.contains('sun'):
		var sun_seed:Consumable = sun_seed_scene.instantiate()
		sun_seed.name = str(data.name)
		sun_seed.scale = data.scale
		sun_seed.position = data.position
		sun_seed.rotation = data.rotation
		get_node("/root/Main").add_child(sun_seed)
	
	if c_name.contains('pumpkin'):
		var pumpkin_seed:Consumable = pumpkin_seed_scene.instantiate()
		pumpkin_seed.name = str(data.name)
		pumpkin_seed.scale = data.scale
		pumpkin_seed.position = data.position
		pumpkin_seed.rotation = data.rotation
		get_node("/root/Main").add_child(pumpkin_seed)


func request_poop_attack(position, direction, requester_id):
	rpc_id(1, 'process_poop_attack', position, direction, requester_id)

@rpc("any_peer")
func receive_poop_attack(position, direction, size, rotation, consumable_name, requester_id):
	var poop:Consumable = poop_scene.instantiate()
	poop.set_multiplayer_authority(requester_id)
	poop.init(requester_id, position, direction, size, rotation)
	poop.name = consumable_name
	get_node("/root/Main").add_child(poop)

func request_spit_nut(position, direction, requester_id):
	rpc_id(1, 'process_spit_nut', position, direction, requester_id)

@rpc("any_peer")
func receive_spit_nut(position, direction, size, rotation, consumable_name, requester_id):
	var lc_name = str(consumable_name).to_snake_case()
	var nut = sun_seed_scene.instantiate() if lc_name.contains('sun') else pumpkin_seed_scene.instantiate()
	nut.set_multiplayer_authority(requester_id)
	nut.init(requester_id, position, direction, size, rotation)
	nut.name = consumable_name
	get_node('/root/Main').add_child(nut)


# server project calls
@rpc("any_peer")
func process_poop_attack(position, direction, requester_id): pass

@rpc("any_peer")
func process_spit_nut(position, direction, requester_id): pass
