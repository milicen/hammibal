extends VBoxContainer

@export var input: LineEdit
@export var join_btn: Button

@export var is_popup: bool
@export var root: Control

signal join_game(host_type)

# Called when the node enters the scene tree for the first time.
func _ready():
	join_btn.connect('pressed', _on_join_btn_pressed)
	if is_popup:
		root.hide()


func _on_line_edit_text_changed(new_text):
	if new_text != '' and is_btn_disabled():
		toggle_join_btn(false)
		return
	
	if new_text == '' and !is_btn_disabled():
		toggle_join_btn(true)
		return


func is_btn_disabled() -> bool:
	return join_btn.disabled == true


func toggle_join_btn(disabled:bool):
	if disabled:
		join_btn.disabled = true
		join_btn.mouse_filter = MOUSE_FILTER_IGNORE
	else:
		join_btn.disabled = false
		join_btn.mouse_filter = MOUSE_FILTER_STOP


func _on_join_btn_pressed():
	AudioManager.play_btn()
	if is_popup:
		root.hide()
		return
	
	var type = input.text
	
	emit_signal('join_game', type)

