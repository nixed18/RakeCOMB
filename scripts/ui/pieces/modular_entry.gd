extends PanelContainer

var normal_panel = preload("res://pieces/account_entry_base_panel.tres")
var normal_colour = Color(1, 1, 1, 0.937255)
var dark_panel = preload("res://pieces/account_entry_dark_panel.tres")
var dark_colour = Color( 0.88, 0.88, 0.88, 0.5 )
var less_dark = Color( 1.0, 1.0, 1.0, 0.7 )

#signal sweep_button_pressed(url, ext)
signal account_button_pressed(url, ext)

var pubkey = String()
var burnt = false
var sweep = true
var mine = true

onready var pubkey_entry = $VBoxContainer/always/pubkey_entry
onready var balance_entry = $VBoxContainer/always/balance_entry

onready var mine_box = $VBoxContainer/mine_box
onready var mine_label = $VBoxContainer/mine_box/label
onready var mine_entry = $VBoxContainer/mine_box/mine_entry
onready var sweep_button = $VBoxContainer/mine_box/sweep_button

onready var wallet_box = $VBoxContainer/wallet_box
onready var pay_button = $VBoxContainer/wallet_box/pay_button
onready var stealth_button = $VBoxContainer/wallet_box/stealth_button
onready var active_spend_button = $VBoxContainer/wallet_box/active_spend_button
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

onready var change_box = $VBoxContainer/change_box
onready var change_button = $VBoxContainer/change_box/change_button



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func toggle(button, onoff):
	if onoff:
		button.modulate.a=1.0
		button.disabled = false
	else:
		button.modulate.a=0.0
		button.disabled = true

#WALLET
func setup_for_wallet(content):
	wallet_box.show()
	#content is just the pubkey
	pubkey = content
	var balance = accounts.get_info(pubkey, "balance")
	var spend_url = accounts.get_info(pubkey, "spend_url")
	var spend_id = accounts.get_info(pubkey, "spend_id")
	var spend_funder = accounts.get_info(pubkey, "spend_funder")
	var spend_block = accounts.get_info(pubkey, "spend_block")
	
	pubkey_entry.text = content
	balance_entry.text = balance+" COMB"
	
	toggle(active_spend_button, false)
	toggle(pay_button, false)
	
	if balance != "0.00000000":
		if spend_url == "" and spend_funder == "":
			toggle(pay_button, true)
			pay_button.other_data = pubkey
			#toggle(active_spend_button, false)
			#active_spend_button.disabled = true
	
#	if content[2]:
#		pay_button.show()
#		pay_button.other_data = content[0]
		
	#active spend
	if not spend_url == "":
		toggle(pay_button, false)
		#pay_button.disabled = true
		toggle(active_spend_button, true)
		#active_spend_button.disabled = false
		tx_id_button.text = "View TX Data - "+spend_id
		tx_id_button.other_data = spend_url
		if spend_funder == "":
			status_entry.text = "Pending"
		else:
			#Also change font colour, but code that later
			burn()
			set("custom_styles/panel", dark_panel)
			burnt = true
			status_entry.text = "Committed"
			source_entry.text = spend_funder
			block_entry.text = spend_block
			source_box.show()
			block_box.show()
	else:
		#No spend, but address commited
		if spend_funder != "":
			toggle(pay_button, false)
			#pay_button.disabled = true
			toggle(active_spend_button, true)
			#active_spend_button.disabled = false
			tx_id_button.text = "TX Data Not Found"
			#tx_id_button.other_data = content[3][0][0]
			#Also change font colour, but code that later
			burn()
			set("custom_styles/panel", dark_panel)
			burnt = true
			status_entry.text = "Committed"
			source_entry.text = spend_funder
			block_entry.text = spend_block
			source_box.show()
			block_box.show()
			
	hide()
	show()
			
#CHANGE ADD
func setup_for_change_add(content):
	#[pubkey, other_data]
	pubkey = content[0]
	pubkey_entry.text = pubkey
	balance_entry.text = accounts.get_info(pubkey, "balance")
	
	change_button.other_data=content[1]
	change_box.show()
	pass
	
func setup_for_multipay(content):
	#[pubkey, amount]
	pubkey = content[0]
	pubkey_entry.text = pubkey
	balance_entry.text = content[1]
	
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

#[comb_address, balance, mine_address, sweep_link]

func setup_for_stealth(content):
	if content == null:
		hide()
		return
	reset_stealth()
	pubkey_entry.text = content[0]
	balance_entry.text = content[1]+" COMB"
	if content[2] != "":
		mine_entry.text = content[2]
	else:
		burn_mine()
	if content[3] != "":
		sweep_button.other_data = content[3]
	else:
		burn_sweep()
	
	hide()
	show()
	pass
	
func reset_stealth():
	mine_box.show()
	mine_label.show()
	mine_entry.show()
	sweep_button.show()
	sweep = true
	mine = true
	set("custom_styles/panel", normal_panel)
	pubkey_entry.set("custom_colors/font_color_uneditable", normal_colour)
	balance_entry.set("custom_colors/font_color_uneditable", normal_colour)
	hide()
	show()
	
	
func burn_full():
	mine_box.hide()
	set("custom_styles/panel", dark_panel)
	pubkey_entry.set("custom_colors/font_color_uneditable", dark_colour)
	balance_entry.set("custom_colors/font_color_uneditable", dark_colour)
	hide()
	show()
	
func burn_sweep():
	balance_entry.text = "0.00000000 COMB"
	sweep_button.hide()
	sweep = false
	if not mine:
		burn_full()
	
	
func burn_mine():
	mine_label.hide()
	mine_entry.hide()
	mine = false
	if not sweep:
		burn_sweep()
	pass
	
	
func _on_pay_button_menu_button_pressed(url, other_data):
	emit_signal("account_button_pressed", url, pubkey)

func _on_stealth_button_menu_button_pressed(url, other_data):
	emit_signal("account_button_pressed", url, pubkey+"/"+"0000000000000000")

func _on_tx_id_button_menu_button_pressed(url, other_data):
	if other_data != "null":
		emit_signal("account_button_pressed", url, other_data)

func _on_sweep_button_menu_button_pressed(url, other_data):
	#print(url+other_data)
	burn_sweep()
	emit_signal("account_button_pressed", url, other_data)
	

func _on_active_spend_button_menu_button_pressed(url, other_data):
	active_spend_box.visible = not active_spend_box.visible
	hide()
	show()


func _on_change_button_menu_button_pressed(url, other_data):
	emit_signal("account_button_pressed", url, other_data)
