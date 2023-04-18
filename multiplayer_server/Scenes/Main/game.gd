extends Node

var poop = preload("res://Scenes/Instances/consumable/poop.tscn")

#client porject calls
@rpc("any_peer")
func receive_poop_attack(position, direction, size, rotation, consumable_name, requester_id):
	pass

# server project calls
@rpc("any_peer")
func process_poop_attack(position, direction, requester_id): 
	var p = poop.instantiate()
	p.set_multiplayer_authority(requester_id)
	get_node("/root/Main").add_child(p, true)
	var rand_size = randf_range(0.4, 0.6)
	var rand_rotation = randf_range(0, 2*PI)
	rpc('receive_poop_attack', position, direction, rand_size, rand_rotation, p.name, requester_id)
