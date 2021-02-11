extends "res://scripts/ui/sub_menus/_sub_menu_base.gd"

signal validator_button_pressed(url, ext)

var row_temp = preload("res://pieces/validator_entry.tscn")

var copy_string = String()

onready var rows = $main_fade_box3/rows
onready var rows_list = $main_fade_box3/rows/ScrollContainer/rows_list
onready var locator = $main_fade_box3/locator
onready var title = $main_fade_box3/title
onready var scroll = $main_fade_box3/rows/ScrollContainer
onready var all_diff = $main_fade_box3/buttons/all_diff
onready var all_same = $main_fade_box3/buttons/all_same


func _ready():
	connect("launched", self, "_on_launched")
	spawn_rows(16)
	

func _on_launched(content):
	#[locator, block, show_allbuttons, [buttons_data], [row_data]]
	#show_allbuttons: 0 = yes, 1 = no and throw, 2 = no
	if content == null:
		return
	if content[0] == "OVERFLOW":
		popups.open("text", ["Data Overflow", "Please make sure there are no other viable options before you press \"No Data.\"", "Okay", null])
		return
	#clear()
	if content[0][0] != "n":
		locator.text = "Locator is "+content[0]
		title.text = "Validating BTC Blocks 0 to "+content[1]
		if content[2] == 0:
			all_diff.show()
			all_same.show()
			all_diff.other_data = content[3][0]
			all_same.other_data = content[3][1]
		elif content[2] == 2:
			all_diff.hide()
			all_same.hide()
		elif content[2] == 1:
			all_diff.hide()
			all_same.hide()
			popups.open("text", ["Block Isolated", "Problem appears to be close to block "+content[1]+".\nUse the rwo options to isolate further.\nIf everything is different, click the first row's \"Different\" button.", "Okay", null])
		setup_rows(content[4])
		set_copystring(content[4])
	else:
		popups.open("valid", ["Results", content, "Done", null])
	
			

func set_copystring(array):
	copy_string = String()
	for info in array:
		copy_string+="Row "+str(info[0]+1)+": "+info[1]+" "+info[2]+"\n"
		
	copy_string = copy_string.strip_edges()
	#debug.p(copy_string)
		

func clear():
	for row in rows_list.get_children():
		row.queue_free()

func spawn_row():
	var row = row_temp.instance()
	rows_list.add_child(row)
	#row.setup(info)
	row.connect("row_button_clicked", self, "_on_row_button_clicked")

func setup_rows(list):
	if list.size() != rows_list.get_child_count():
		debug.p(["VALIDATOR: mismatched sizes", list.size(), rows_list.get_child_count()])
	else:
		var i = 0
		var row_entries = rows_list.get_children()
		while i < list.size():
			row_entries[i].setup(list[i])
			i+=1
			
		var new_x = rows_list.rect_size.x+38
		rows.rect_position.x -= (new_x-rows.rect_size.x)/2 
		rows.rect_size.x = new_x
		hide()
		show()
		scroll.scroll_vertical=0

func spawn_rows(n):
	var i = 0
	while i < n:
		spawn_row()
		i+=1

func spawn_rows_old(list):
	for info in list:
		#spawn_row(info)
		pass

	var new_x = rows_list.rect_size.x+38
	rows.rect_position.x -= (new_x-rows.rect_size.x)/2 
	rows.rect_size.x = new_x
	hide()
	show()
	scroll.scroll_vertical=0


func _on_row_button_clicked(url, ext):
	emit_signal("validator_button_pressed", url, ext)
	pass

func _on_all_diff_menu_button_pressed(url, other_data):
	emit_signal("validator_button_pressed", url, other_data)

func _on_all_same_menu_button_pressed(url, other_data):
	emit_signal("validator_button_pressed", url, other_data)


func _on_copy_menu_button_pressed(url, other_data):
	OS.set_clipboard(copy_string)
