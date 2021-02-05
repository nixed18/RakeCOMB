extends PanelContainer

var dark_panel = preload("res://pieces/account_entry_dark_panel.tres")
var dark_colour = Color( 0.88, 0.88, 0.88, 0.5 )

signal sweep_button_pressed(url, ext)

var sweep = true
var mine = true

onready var pubkey_entry = $VBoxContainer/HBoxContainer/pubkey_entry
onready var balance_entry = $VBoxContainer/HBoxContainer/balance_entry
onready var mine_box = $VBoxContainer/mine_box
onready var mine_label = $VBoxContainer/mine_box/label
onready var mine_entry = $VBoxContainer/mine_box/mine_entry
onready var sweep_button = $VBoxContainer/mine_box/sweep_button



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#[comb_address, balance, mine_address, sweep_link]
func setup(content):
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
	


func _on_sweep_button_menu_button_pressed(url, other_data):
	#print(url+other_data)
	burn_sweep()
	emit_signal("sweep_button_pressed", url, other_data)
