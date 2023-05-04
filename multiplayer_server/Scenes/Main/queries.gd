extends Node


func insert_new_player(new_player):
	var query = SupabaseQuery.new().from('players').insert([new_player])
	var result = await Supabase.database.query(query).completed
#	print_debug('insert res: ', result.data)


func update_player(id, data):
	var query = SupabaseQuery.new().from('players').update(data).eq('id', str(id))
	var result = await Supabase.database.query(query).completed
#	print_debug('update res: ', result.data)
	pass


func delete_player(id):
	var query = SupabaseQuery.new().from('players').delete().eq('id', str(id))
	var result = await Supabase.database.query(query).completed
	pass

