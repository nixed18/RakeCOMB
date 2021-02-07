extends Control

signal response(response, data)

onready var title = $Panel/Panel/title
onready var yes_button = $Panel/HBoxContainer/yes_button
onready var no_button = $Panel/HBoxContainer/no_button
onready var address_line = $Panel/VBoxContainer/HBoxContainer/address_line
onready var comb_line = $Panel/VBoxContainer/HBoxContainer4/HBoxContainer3/comb_line
onready var nats_line = $Panel/VBoxContainer/HBoxContainer4/HBoxContainer2/nats_line


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	clear()


func open(details):
	show()

func clear():
	address_line.text = ""
	comb_line.text = ""
	nats_line.text = ""

func _on_yes_button_menu_button_pressed(url, other_data):
		emit_signal("response", true, [address_line.text, comb_line.text, nats_line.text])

func _on_no_button_menu_button_pressed(url, other_data):
	emit_signal("response", false, null)
	

	
