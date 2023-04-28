extends Node


var players = []


# Called when the node enters the scene tree for the first time.
func _ready():
	Server.connect_to_server()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_spawner_spawned(node):
	players.append(node)


func _on_player_spawner_despawned(node):
	var player = players.find(node)
	players.erase(player)


func _on_player_order_timer_timeout():
	# mass sort
	var copy = players.duplicate()
	for n in copy.size():
		var index = 0
		
		for m in copy.size():
			var current = copy[index]
			if index+1 > copy.size()-1: break
			var next = copy[index+1]
			
			if current == null or next == null: break
		
			if current.mass > next.mass:
				var tmp = current
				copy[index] = next
				copy[index+1] = tmp
			
			index += 1
	
	players = copy
	for index in players.size():
		if players[index] == null: continue
		players[index].z_index = index
		
	



