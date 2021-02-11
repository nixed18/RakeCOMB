extends "res://scripts/ui/sub_menus/_sub_menu_base.gd"

signal sweep_initiated(url, ext)

var address_template = preload("res://pieces/modular_entry.tscn")

var pubkey = String()
var base_info = "Secret addresses for account #\nTo claim haircomb, send 330 sats to a mine address.\nIf your transaction is at the top of the block, you get the COMB"

onready var panel = $main_fade_box/accounts
onready var address_list = $main_fade_box/accounts/ScrollContainer/address_list
onready var info_text = $main_fade_box/info_text 
onready var scroll = $main_fade_box/accounts/ScrollContainer

func _ready():
	connect("launched", self, "_on_launched")
	connect("hidden", self, "_on_hidden")
	spawn_addresses(256)

func _on_launched(content):
	#print(content)
	pubkey = content[0]
	info_text.text=base_info.replace("#", pubkey)
	#spawn_addresses(content[1])
	setup_addresses(content[1])
	#print(OS.get_ticks_msec())

func _on_hidden():
	#clear_addresses()
	pass

func clear_addresses():
	for address in address_list.get_children():
		address.queue_free()
		
func setup_addresses(list):
	var children = address_list.get_children()
	if list.size() > children.size():
		return
	else:
		var i = 0
		while i < list.size():
			children[i].setup_for_stealth(list[i])
			i+=1
		while i < children.size():
			children[i].setup_for_stealth(null)
			i+=1
	address_list.hide()
	address_list.show()
	#displace
	var new_x = address_list.rect_size.x+38
	panel.rect_position.x -= (new_x-panel.rect_size.x)/2 
	panel.rect_size.x = new_x
	hide()
	show()
	scroll.scroll_vertical=0

func spawn_address():
	var new_address = address_template.instance()
	address_list.add_child(new_address)
	#new_address.base_setup_for_stealth()
	new_address.connect("account_button_pressed", self, "_on_sweep_button_pressed")

func spawn_address_old(address_info):
	var new_address = address_template.instance()
	address_list.add_child(new_address)
	new_address.setup_for_stealth(address_info)
	new_address.connect("account_button_pressed", self, "_on_sweep_button_pressed")

func spawn_addresses(n):
	var x = 0
	while x < n:
		x+=1
		spawn_address()

	
	address_list.hide()
	address_list.show()
	#displace
#	var new_x = address_list.rect_size.x+38
#	panel.rect_position.x -= (new_x-panel.rect_size.x)/2 
#	panel.rect_size.x = new_x
#	hide()
#	show()
#	scroll.scroll_vertical=0
	

func spawn_addresses_old(list):
	for info in list:
		pass
#		spawn_address(info)
	address_list.hide()
	address_list.show()
	#displace
	var new_x = address_list.rect_size.x+38
	panel.rect_position.x -= (new_x-panel.rect_size.x)/2 
	panel.rect_size.x = new_x
	hide()
	show()
	scroll.scroll_vertical=0
	
func _on_sweep_button_pressed(url, ext):
	emit_signal("sweep_initiated", url, ext)
	
