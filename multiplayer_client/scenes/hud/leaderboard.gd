extends VBoxContainer


var list_item = preload("res://scenes/hud/leaderboard_list.tscn")

@onready var list = $List

# Called when the node enters the scene tree for the first time.
func _ready():
	for n in 10:
		var li = list_item.instantiate()
		li.z_index = n * -1
		list.add_child(li)
		li.set_list_data('-', '-', n+1)
	pass # Replace with function body.




func _on_timer_timeout():
	Game.request_in_game_players()
	await Game.received_in_game_players
	var players = Game.in_game_players
	players.sort_custom(sort)
	var sorted = players.slice(0, min(10, players.size()))
	
	print(players)
	
	var list_items = list.get_children()
	var index = 0
	for n in sorted.size():
		var num = n-index
		var li = list_items[num]
		
		var player_node = get_node_or_null("/root/Main/%s" % str(sorted[n].id))
#		print('player node: ', player_node)
		if !player_node: 
			li.set_list_data('-', '-')
			index += 1
		else:
			li.set_list_data(str(player_node.username), player_node.mass)
	
	

func sort(a,b):
	var player_a = get_node_or_null("/root/Main/%s" % str(a.id))
	var player_b = get_node_or_null("/root/Main/%s" % str(b.id))
	
	if !player_a or !player_b: return -1
	
	if player_a.mass > player_b.mass:
		return -1
	if player_a.mass < player_b.mass:
		return 1
