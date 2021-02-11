extends "res://scripts/ui/sub_menus/_sub_menu_base.gd"

signal validate_requested(url, ext)

onready var main_box = $main_fade_box
onready var fingerprint = $main_fade_box/VBoxContainer/fingeprint_box2/VBoxContainer/fingerprint
onready var f_size = $main_fade_box/VBoxContainer/fingeprint_box2/VBoxContainer/size
onready var synced = $main_fade_box/VBoxContainer/stats_box2/VBoxContainer/sync
onready var mined = $main_fade_box/VBoxContainer/stats_box2/VBoxContainer/mined
onready var remain = $main_fade_box/VBoxContainer/stats_box2/VBoxContainer/remain
onready var validate_button = $main_fade_box/VBoxContainer/HBoxContainer/validate_database

func _ready():
	connect("launched", self, "_on_launched")

#Content = [in_sync, fingerprint, size, mined, sync, remaining, bisect]
func _on_launched(content):
	fingerprint.text = content[1]
	f_size.text = "Fingerprint of commitment set of size "+content[2]
	synced.text = "Synced to Bitcoin block "+content[4]
	mined.text = content[3]+" COMB have been mined"
	remain.text = content[5]+" COMB remain"
	validate_button.other_data = "b"+content[6]
	
	reset_main_box()
	pass
	
func reset_main_box():
	main_box.hide()
	main_box.show()
	pass


func _on_validate_database_menu_button_pressed(url, other_data):
	print([url, other_data])
	emit_signal("validate_requested", url, other_data)
	#USE LATER, FOR NOW JUST USE THE DEFAULT
#	popups.open("line", ["Validate Database", "Choose a block", "Validate", "Cancel", validate_button.other_data])
#	var response = yield(popups, "response") #[yesno, block_number]
#	if response[0]:
#		pass
#	else:
#		pass
		
