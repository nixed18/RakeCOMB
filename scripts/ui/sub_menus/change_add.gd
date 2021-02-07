extends "res://scripts/ui/sub_menus/_sub_menu_base.gd"

signal account_button_pressed(url, ext)

var account_template = preload("res://pieces/modular_entry.tscn")

var accounts_array = []

onready var accounts_list = $main_fade_box/accounts/ScrollContainer/accounts_list
onready var scroll = $main_fade_box/accounts/ScrollContainer

func _ready():
	connect("launched", self, "_on_launched")
	connect("hidden", self, "_on_hidden")
	

func _on_launched(content):
	#clear_accounts()
	if content != null:
		spawn_accounts(content)
	else:
		#Do stuff for no addresses found
		no_suitable()
	
func _on_hidden():
	clear_accounts()

func no_suitable():
		frontend.go_to("/wallet/")
		popups.open("text", ["No Change Address", "No suitable Change Addresses could be found\nPlease create an account to use as a change address", "Okay", null])

func clear_accounts():
	for account in accounts_array:
		account.queue_free()
	accounts_array.clear()
	

func spawn_account_entry(account_info):

	if accounts.accounts[account_info[0]].active_spend.url != "":
		return
	if accounts.accounts[account_info[0]].active_spend.funder != "":
		return
		
	var new_account = account_template.instance()
	accounts_list.add_child(new_account)
	accounts_array.append(new_account)
	new_account.setup_for_change_add(account_info)
	new_account.connect("account_button_pressed", self, "_on_account_button_pressed")

func spawn_accounts(list):
	for info in list:
		spawn_account_entry(info)
	if accounts_list.get_children().empty():
		no_suitable()
	scroll.scroll_vertical=0
	

func _on_account_button_pressed(url, ext):
	emit_signal("account_button_pressed", url, ext)

