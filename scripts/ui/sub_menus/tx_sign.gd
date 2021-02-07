extends "res://scripts/ui/sub_menus/_sub_menu_base.gd"

var entry = preload("res://pieces/btc_entry.tscn")

var instruct_text = "1. Click \"Confirm Transaction\" to store the tx locally\n2. Pay 330 satoshis to each of the addresses below\n3. After 6+ block confirmations give the coin history to the receivers\nRemember to save your wallet after confirming the transaction!"

onready var address_list = $main_fade_box/accounts/ScrollContainer/address_list
onready var confirm_button = $main_fade_box/confirm_button
onready var tx_id = $main_fade_box/HBoxContainer/tx_id
onready var pay_to = $main_fade_box/HBoxContainer2/pay_to

func _ready():
	connect("launched", self, "_on_launched")
	connect("hidden", self, "_on_hidden")
	

func _on_launched(content):
	#content = [txid, dest_address, [21_addresses], confirm_ext]
	if content!=null:
		tx_id.text=content[0]
		pay_to.text=content[1]
		spawn_entries(content[2])
		confirm_button.other_data=content[3]
		
	pass
	
func spawn_entry(text):
	var new_entry = entry.instance()
	address_list.add_child(new_entry)
	new_entry.set_text(text)
	
	
	pass
	
func spawn_entries(array):
	for address in array:
		spawn_entry(address)
		
	
func _on_hidden():
	clear()
	
func clear():
	for child in address_list.get_children():
		child.queue_free()
	pass


func _on_instruction_button_menu_button_pressed(url, other_data):
	popups.open("text", ["Payment Instructions", instruct_text, "Okay", null])

