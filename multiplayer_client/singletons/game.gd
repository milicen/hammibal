extends Node


var poop_scene = preload("res://scenes/consumables/poop.tscn")

func instance_consumable(data: Dictionary):
	print_debug('instance consumable')
	var c_name = str(data.name).to_lower()
	if c_name.contains('poop'):
		var poop:Consumable = poop_scene.instantiate()
		poop.name = str(data.name)
		poop.scale = data.scale
		poop.position = data.position
		poop.rotation = data.rotation
		get_node("/root/Main").add_child(poop)
			
			

func request_poop_attack(position, direction, requester_id):
	rpc_id(1, 'process_poop_attack', position, direction, requester_id)

@rpc("any_peer")
func receive_poop_attack(position, direction, size, rotation, consumable_name, requester_id):
	var poop:Consumable = poop_scene.instantiate()
	poop.set_multiplayer_authority(requester_id)
	poop.init(requester_id, position, direction, size, rotation)
	poop.name = consumable_name
	get_node("/root/Main").add_child(poop)

# server project calls
@rpc("any_peer")
func process_poop_attack(position, direction, requester_id): pass
