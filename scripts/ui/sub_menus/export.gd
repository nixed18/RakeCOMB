extends "res://scripts/ui/sub_menus/_sub_menu_base.gd"

signal export_requested(url, ext)

onready var select_box = $select_box
onready var address_entry = $select_box/select_box/address_entry

onready var history_box = $history_box
onready var source_acc = $history_box/source2/source_acc
onready var history_entry = $history_box/history_entry

func _ready():
	connect("launched", self, "_on_launched")
	connect("hidden", self, "_on_hidden")
	

func _on_launched(content):
	if content != null:
		select_box.hide()
		history_box.show()
		source_acc.text = address_entry.text
		history_entry.text = content
	else:
		select_box.show()
		history_box.hide()
		address_entry.text = ""
		
	hide()
	show()
	
func _on_hidden():
	pass

func _on_export_add_menu_button_pressed(url, other_data):
	var formatted = parser.make_basic(address_entry.text)
	if parser.is_pubkey(formatted):
		emit_signal("export_requested", url, formatted)
	else:
		popups.open("text", ["Error", "Please enter a valid public key.", "Okay", null])

func _on_export_full_menu_button_pressed(url, other_data):
	address_entry.text = "Complete History"
	emit_signal("export_requested", url, other_data)

func save_file(file_name, ext, content):
	var f = File.new()
	if f.file_exists(fileman.d_path+"/"+file_name+ext):
		return "dupe"
		
	f.open(fileman.d_path+"/"+file_name+ext, File.WRITE)
	f.store_string(content)
	f.close()
	
	return file_name+ext
	

func _on_dat_menu_button_pressed(url, other_data):
	popups.open("line", ["Save History File", "Enter a filename", "Okay", "Cancel", ""])
	var response = yield(popups, "response")
	
	if response[0]:
		var file_name = parser.make_basic(response[1])
		var result = save_file(file_name, ".dat", history_entry.text)
		if result == "dupe":
			popups.open("text", ["Error", "A file by that name already exists.", "Okay", null])
		else:
			popups.open("text", ["File Saved", "File saved as "+result, "Okay", null])
			frontend.go_to("/export/index.html")
			
	else:
		pass
		
