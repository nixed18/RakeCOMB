extends "res://scripts/ui/sub_menus/_sub_menu_base.gd"


onready var text_edit = $main_fade_box/TextEdit

func _ready():
	connect("launched", self, "_on_launched")
	

func _on_launched(content):
	if content == null:
		return
	clear()
	add_row("Block Number: "+content[0])
	add_row("")
	var i = 0
	while i < content[1].size():
		add_row("Row "+str(i+1)+": "+content[1][i][0]+" "+content[1][i][1])
		i+=1
	
func add_row(text):
	text_edit.text += text+"\n"

func clear():
	text_edit.text = ""

#func spawn_account_entry(account_info):
#	var new_account = account_template.instance()
#	accounts_list.add_child(new_account)
#	accounts_array.append(new_account)
#	new_account.setup_for_wallet(account_info)
#	new_account.connect("account_button_pressed", self, "_on_account_button_pressed")
#
#func spawn_accounts(list):
#	for info in list:
#		accounts.store_account(info)
#		spawn_account_entry(info[0])
#
#	var new_x = accounts_list.rect_size.x+38
#	panel.rect_position.x -= (new_x-panel.rect_size.x)/2 
#	panel.rect_size.x = new_x
#	hide()
#	show()
#	accounts_list.move_child(gen_box, accounts_list.get_child_count()-1)
#	scroll.scroll_vertical=0
