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


func insert_new_team():
	var uid = Utils.generate_uid(6)
	var new_team = {
		'code': uid
	}
	var query = SupabaseQuery.new().from('teams').insert([new_team])
	var result = await Supabase.database.query(query).completed
	return result.data
	if result:
		print('new team: ', result.data)


func get_team(code):
	var query = SupabaseQuery.new().from('teams').select().eq('code', code)
	var result = await Supabase.database.query(query).completed
	return result.data
	if result:
		print('get team: ', result.data)
