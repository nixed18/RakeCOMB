extends Control

signal response(response)

onready var title = $Panel/Panel/title
onready var main = $Panel/VBoxContainer/response_text
onready var yes_button = $Panel/HBoxContainer/yes_button
onready var no_button = $Panel/HBoxContainer/no_button
onready var line = $Panel/VBoxContainer/HBoxContainer/line_entry


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


func open(details):
	#[title_text, main_text, yes_text, no_text, line_edit text]
	title.text = details[0]
	main.text = details[1]
	
	if details[2] != null:
		yes_button.text = details[2]
		yes_button.show()
	else:
		yes_button.hide()
		
	if details[3] != null:
		no_button.text = details[3]
		no_button.show()
	else:
		no_button.hide()
		
	line.text = details[4]
		
	show()


func _on_yes_button_menu_button_pressed(url, other_data):
	if line.text != "":
		emit_signal("response", true, line.text)

func _on_no_button_menu_button_pressed(url, other_data):
	emit_signal("response", false, null)
	
