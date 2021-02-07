extends "res://scripts/ui/sub_menus/_sub_menu_base.gd"

signal account_button_pressed(url, ext)

var account_template = preload("res://pieces/modular_entry.tscn")

var accounts_array = []

var pubkey = null
var change = null
var stack = null

var base_source_text = "will fund the transaction with # COMB"
var base_change_text = "#1 COMB will be spent. The remaining #2 COMB will be sent to:"

onready var source_acc = $main_fade_box/source/source_acc
onready var source_text = $main_fade_box/source/source_text
onready var change_acc = $main_fade_box/change/change_acc
onready var change_text = $main_fade_box/change/change_text

onready var add_box = $main_fade_box/accounts/ScrollContainer/accounts_list/add_box
onready var add_button = $main_fade_box/accounts/ScrollContainer/accounts_list/add_box/add_receiver
onready var execute_button = $main_fade_box/execute

onready var panel = $main_fade_box/accounts
onready var accounts_list = $main_fade_box/accounts/ScrollContainer/accounts_list
onready var scroll = $main_fade_box/accounts/ScrollContainer

func _ready():
	connect("launched", self, "_on_launched")
	connect("hidden", self, "_on_hidden")
	
	
func _on_launched(content):
	#Content = #[pubkey, change, [recv_array], stack]
	#dest_array = [[dest_add1, amount_sent], [dest_add2, amount_sent], etc]
	if content != null:
		pubkey = content[0]
		change = content[1]
		spawn_accounts(content[2])
		stack = content[3]
		set_text(content)
		#execute_button.other_data = content[3]

	
func _on_hidden():
	clear_accounts()

func clear_accounts():
	for account in accounts_array:
		account.queue_free()
	accounts_array.clear()

func set_text(content):
	source_acc.text = pubkey
	source_text.text = base_source_text.replace("#", accounts.accounts[pubkey].balance)
	
	change_acc.text = change
	
	#Get sent total
	var sent = 0
	for info in content[2]:
		sent+= float(info[1])
	
	var remaining = float(accounts.accounts[pubkey].balance)-sent

	change_text.text = base_change_text.replace("#1", str(sent))
	change_text.text = change_text.text.replace("#2", str(remaining))


func spawn_account_entry(account_info):
	var new_account = account_template.instance()
	accounts_list.add_child(new_account)
	accounts_array.append(new_account)
	new_account.setup_for_multipay(account_info)
	new_account.connect("account_button_pressed", self, "_on_account_button_pressed")

func spawn_accounts(list):
	for info in list:
		spawn_account_entry(info)
	accounts_list.move_child(add_box, accounts_list.get_child_count()-1)
	scroll.scroll_vertical=0
	

func _on_account_button_pressed(url, ext):
	emit_signal("account_button_pressed", url, ext)


func _on_add_receiver_menu_button_pressed(url, other_data):
	popups.open("recv", [])
	var response = yield(popups, "response")
	if not response[0]:
		pass
	else:
		#Verify the info is viable, if so then send out
		if not parser.is_pubkey(response[1][0]):
			return
		if not parser.is_comb(response[1][1]):
			return
		if not parser.is_comb(response[1][2]):
			return
			
			
		#assemble new_add
		var new_add = response[1][0]#pubkey
		#Add zeros
		
		while response[1][2].length() < 8:
			response[1][2] += "0"
			
		var dec = parser.dec2hex_string(response[1][1]+response[1][2])
		
		#print(dec)
		
		while dec.length() < 16:
			dec = "0"+dec
			
		#print(dec)
		
		new_add+=dec
			
		#print("/stack/multipaydata/"+pubkey+"/"+change+"/"+stack+new_add)
		
		emit_signal("account_button_pressed", "/stack/multipaydata/", pubkey+"/"+change+"/"+stack+new_add)
		


func _on_execute_menu_button_pressed(url, other_data):
	emit_signal("account_button_pressed", url, pubkey+"/"+stack)
