extends Node


var players = []


func show_hud():
	$HUD.show()
	$HUD.set_hud()

func hide_hud():
	$HUD.hide()

func set_team_data():
	$HUD.set_team()

func _on_player_spawner_spawned(node):
	players.append(node)


func _on_player_spawner_despawned(node):
	var player = players.find(node)
	players.erase(player)


func _on_player_order_timer_timeout():
	# mass sort
	var copy = players.duplicate()
	copy.sort_custom(sort_asc)
	
	for i in copy.size():
		if copy[i] == null: continue
		copy[i].z_index = i


func sort_asc(a,b):
	if !a or !b: return false
	return a.mass < b.mass



