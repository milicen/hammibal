extends Node




func _on_timer_timeout():
	if get_tree().get_nodes_in_group('consumable').size() < 100:
		Game.spawn_consumable()
