extends "res://scripts/ui/sub_menus/_sub_menu_base.gd"

signal import_requested(url, file_path)

onready var import_entry = $main_fade_box/VBoxContainer/import_entry
onready var import_button = $main_fade_box/VBoxContainer/HBoxContainer/import_button

onready var file_path = null


func _ready():
	connect("launched", self, "_on_launched")
	connect("hidden", self, "_on_hidden")
	

func _on_launched(content):
	if content != null:
		content = format(content)
		popups.open("text", ["Import Data", content, "Okay", null])
	
func _on_hidden():
	file_path = null
	import_entry.text = ""
	
func format(content):
	var string = "Imported:\n#1 Stack#11 \n#2 Transaction#22 \n#3 Merkle Tree#33 \n#4 Key#44 \n#5 Decider#55"
	var i = 0
	while i < 5:
		if int(content[i]) != 1:
			string = string.replace("#"+str(i+1)+str(i+1), "s")
		else:
			string = string.replace("#"+str(i+1)+str(i+1), "")
		string = string.replace("#"+str(i+1), content[i])
		i+=1
			
	return string

func _on_import_button_menu_button_pressed(url, other_data):
	if file_path != null:
		emit_signal("import_requested", url, [other_data, file_path])


func _on_save_entry_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.is_pressed():
			popups.open("file_select", ["Select a .dat file", "Warning: Do not open two Wallets at once", null, "Cancel" ])
			var response = yield(popups, "response")
			if response[0]:
				import_entry.text = response[1].get_file()
				file_path = response[1]
			else:
				import_entry.text = ""
				file_path = null
				
				
				
