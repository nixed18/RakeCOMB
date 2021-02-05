extends PanelContainer

signal account_button_pressed(url, ext)

var dark_panel = preload("res://pieces/account_entry_dark_panel.tres")
var dark_colour = Color( 0.88, 0.88, 0.88, 0.5 )

var pubkey = String()
var burnt = false

onready var pubkey_entry = $VBoxContainer/HBoxContainer/pubkey_entry
onready var balance_entry = $VBoxContainer/HBoxContainer/balance_entry

onready var pay_button = $VBoxContainer/HBoxContainer2/pay_button
onready var stealth_button = $VBoxContainer/HBoxContainer2/stealth_button
onready var active_spend_button = $VBoxContainer/HBoxContainer2/active_spend_button
onready var active_spend_box = $VBoxContainer/active_spend_box

onready var tx_id_button = $VBoxContainer/active_spend_box/VBoxContainer/tx_id_button
onready var status_box = $VBoxContainer/active_spend_box/VBoxContainer/VBoxContainer/status_box
onready var status_label = $VBoxContainer/active_spend_box/VBoxContainer/VBoxContainer/status_box/status_label
onready var status_entry = $VBoxContainer/active_spend_box/VBoxContainer/VBoxContainer/status_box/status_entry
onready var source_box = $VBoxContainer/active_spend_box/VBoxContainer/VBoxContainer/source_box
onready var source_label = $VBoxContainer/active_spend_box/VBoxContainer/VBoxContainer/source_box/source_address
onready var source_entry = $VBoxContainer/active_spend_box/VBoxContainer/VBoxContainer/source_box/source_entry
onready var block_box = $VBoxContainer/active_spend_box/VBoxContainer/VBoxContainer/block_box
onready var block_label = $VBoxContainer/active_spend_box/VBoxContainer/VBoxContainer/block_box/block_height
onready var block_entry = $VBoxContainer/active_spend_box/VBoxContainer/VBoxContainer/block_box/block_entry

func _ready():
	pass # Replace with function body.


#[pubkey, balance, pay_bool, [[active_spend_url, active_spend_id], [btc_address_that_spent, block_number]]]
func setup(content):
	#print(content)
	pubkey = content[0]
	pubkey_entry.text = content[0]
	balance_entry.text = content[1]+" COMB"
	if content[2]:
		pay_button.show()
		pay_button.other_data = content[0]
		
	#active spend
	if not content[3][0][0] == "":
		pay_button.hide()
		active_spend_button.show()
		tx_id_button.text = "View TX Data - "+content[3][0][1]
		tx_id_button.other_data = content[3][0][0]
		if content[3][1][0] == "":
			status_entry.text = "Pending"
		else:
			#Also change font colour, but code that later
			burn()
			set("custom_styles/panel", dark_panel)
			burnt = true
			status_entry.text = "Committed"
			source_entry.text = content[3][1][0]
			block_entry.text = content[3][1][1]
			source_box.show()
			block_box.show()
	else:
		#No spend, but address commited
		if content[3][1][0] != "":
			pay_button.hide()
			active_spend_button.show()
			tx_id_button.text = "TX Data Not Found"
			#tx_id_button.other_data = content[3][0][0]
			#Also change font colour, but code that later
			burn()
			set("custom_styles/panel", dark_panel)
			burnt = true
			status_entry.text = "Committed"
			source_entry.text = content[3][1][0]
			block_entry.text = content[3][1][1]
			source_box.show()
			block_box.show()
		
	
	#BTC without the active spend
			
	hide()
	show()
		
	
	pass

func burn():
	pubkey_entry.set("custom_colors/font_color_uneditable", dark_colour)
	balance_entry.set("custom_colors/font_color_uneditable", dark_colour)
	stealth_button.set("custom_colors/font_color", dark_colour)
	active_spend_button.set("custom_colors/font_color", dark_colour)
	tx_id_button.set("custom_colors/font_color", dark_colour)
	status_label.set("custom_colors/font_color", dark_colour)
	status_entry.set("custom_colors/font_color", dark_colour)
	source_label.set("custom_colors/font_color", dark_colour)
	source_entry.set("custom_colors/font_color_uneditable", dark_colour)
	block_label.set("custom_colors/font_color", dark_colour)
	block_entry.set("custom_colors/font_color_uneditable", dark_colour)

func _on_active_spend_button_menu_button_pressed(url, other_data):
	active_spend_box.visible = not active_spend_box.visible
	hide()
	show()


func _on_pay_button_menu_button_pressed(url, other_data):
	emit_signal("account_button_pressed", url, pubkey)

func _on_stealth_button_menu_button_pressed(url, other_data):
	emit_signal("account_button_pressed", url, pubkey+"/"+"0000000000000000")

func _on_tx_id_button_menu_button_pressed(url, other_data):
	if other_data != "null":
		emit_signal("account_button_pressed", url, other_data)
