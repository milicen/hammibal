extends Container

@export var texture_rect: TextureRect
@export var label: Label

var default_texture = preload('res://assets/ui/profile_empty.png')

func set_data(data):
	if data == null:
		texture_rect.texture = default_texture
		label.text = '???'
		return
	texture_rect.texture = HamsterData.hamsters[data.hamster_index].profile
	label.text = data.username if data.username != null else ''
