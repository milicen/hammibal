extends VBoxContainer

@export var input: LineEdit
@export var join_btn: Button
@export var root: Control

signal join_game(host_type)


func is_btn_disabled() -> bool:
	return join_btn.disabled == true


func toggle_join_btn(disabled:bool):
	if disabled:
		join_btn.disabled = true
		join_btn.mouse_filter = MOUSE_FILTER_IGNORE
	else:
		join_btn.disabled = false
		join_btn.mouse_filter = MOUSE_FILTER_STOP


func _on_player_name_input_text_changed(new_text):
	if new_text != '' and is_btn_disabled():
		toggle_join_btn(false)
		return
	
	if new_text == '' and !is_btn_disabled():
		toggle_join_btn(true)
		return


func _on_join_game_button_pressed():
	AudioManager.play_btn()
	emit_signal('join_game')
