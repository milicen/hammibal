extends Container

@export var texture_rect: TextureRect
@export var label: Label

func set_data(data):
	if data == null:
		return
	texture_rect.texture = HamsterData.hamsters[data.hamster_index].profile
	label.text = data.username
