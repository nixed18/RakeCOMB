extends "res://scripts/ui/sub_menus/_sub_menu_base.gd"

signal account_button_pressed(url, ext)

var account_template = preload("res://pieces/account_entry.tscn")

var accounts_array = []

onready var accounts_list = $main_fade_box/accounts/ScrollContainer/accounts_list
onready var scroll = $main_fade_box/accounts/ScrollContainer
onready var gen_button = $main_fade_box/accounts/ScrollContainer/accounts_list/key_box/generate_key
onready var gen_box = $main_fade_box/accounts/ScrollContainer/accounts_list/key_box

func _ready():
	connect("launched", self, "_on_launched")
	connect("hidden", self, "_on_hidden")
	

func _on_launched(content):
	#clear_accounts()
	spawn_accounts(content)
	
func _on_hidden():
	clear_accounts()

func clear_accounts():
	for account in accounts_array:
		account.queue_free()
	accounts_array.clear()
	

func spawn_account_entry(account_info):
	var new_account = account_template.instance()
	accounts_list.add_child(new_account)
	accounts_array.append(new_account)
	new_account.setup(account_info)
	new_account.connect("account_button_pressed", self, "_on_account_button_pressed")

func spawn_accounts(list):
	for info in list:
		spawn_account_entry(info)
	accounts_list.move_child(gen_box, accounts_list.get_child_count()-1)
	scroll.scroll_vertical=0
	

func _on_account_button_pressed(url, ext):
	emit_signal("account_button_pressed", url, ext)


func _on_generate_key_menu_button_pressed(url, other_data):
	var main = "Are you sure? Remember to save afterwards!"
	popups.open("text", ["Confirm", main, "Okay", "Cancel"])
	var response = yield(popups, "response")
	if response[0]:
		emit_signal("account_button_pressed", url, "")
