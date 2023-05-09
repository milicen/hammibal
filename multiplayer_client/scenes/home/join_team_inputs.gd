extends VBoxContainer

@export var input: LineEdit
@export var join_btn: Button
@export var warning_label: Label
@export var progress_label: Label
@export var root: Control
@export var team_container: Control

signal join_team(team_code)

func is_btn_disabled() -> bool:
	return join_btn.disabled == true


func toggle_join_btn(disabled:bool):
	if disabled:
		join_btn.disabled = true
		join_btn.mouse_filter = MOUSE_FILTER_IGNORE
	else:
		join_btn.disabled = false
		join_btn.mouse_filter = MOUSE_FILTER_STOP


func _on_team_code_input_text_changed(new_text):
	if new_text != '' and is_btn_disabled():
		toggle_join_btn(false)
		return
	
	if new_text == '' and !is_btn_disabled():
		toggle_join_btn(true)
		return


func _on_join_team_button_pressed():
	progress_label.hide()
	warning_label.hide()
	
	AudioManager.play_btn()
	progress_label.show()
	
	input.editable = false
	join_btn.disabled = true
	
#	join_btn.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	Game.request_join_team(input.text)
	await Game.join_team_completed
	
	progress_label.hide()
	
	if Game.join_team_status == false:
		warning_label.text = Game.join_team_msg
		warning_label.show()
	else:
		root.hide()
		warning_label.hide()
		input.text = ''
		team_container.show_team_code()
		
	input.editable = true
	join_btn.disabled = false
		


func _on_join_team_popup_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		print('clicked')
		root.hide()
		warning_label.hide()
		input.text = ''
