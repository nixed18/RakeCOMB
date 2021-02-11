extends Control

signal response(response, data)

onready var title = $Panel/VBoxContainer/Panel/title
onready var main = $Panel/VBoxContainer/HBoxContainer2/response_text
onready var yes_button = $Panel/VBoxContainer/HBoxContainer/yes_button
onready var no_button = $Panel/VBoxContainer/HBoxContainer/no_button


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


func open(details):
	#[title_text, main_text, yes_text, no_text]
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
		
	show()
	hide()
	show()


func _on_yes_button_menu_button_pressed(url, other_data):
	emit_signal("response", true, null)

func _on_no_button_menu_button_pressed(url, other_data):
	emit_signal("response", false, null)
	
