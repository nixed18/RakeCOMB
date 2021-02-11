extends Control

signal response(response, data)

onready var title = $Panel/Panel/title
onready var main = $Panel/TextEdit
onready var yes_button = $Panel/HBoxContainer/yes_button
onready var no_button = $Panel/HBoxContainer/no_button
onready var inst2 = $Panel/instruct_2


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


func open(details):
	title.text = details[0]
	main.text = details[1][1]
	
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
		
	inst2.text = inst2.text.replace("LOCATOR", details[1][0])
		
	show()


func _on_yes_button_menu_button_pressed(url, other_data):
		emit_signal("response", true, null)

