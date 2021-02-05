extends "res://scripts/ui/sub_menus/_sub_menu_base.gd"

signal save_requested(url)

onready var entry = $main_fade_box/VBoxContainer/save_entry

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("launched", self, "_on_launched")
	

func _on_launched(content):
	entry.text = ""
	if content != null:
		#Display the content
		if content[0]:
			#If success
			popups.open("text", ["Save Success", "Saved as: \""+content[1]+"\"", "Okay", null])
			yield(popups, "response")
			return_home()
			pass
		else:
			#If fail
			popups.open("text", ["Save Failed", "A file named \""+content[1]+"\" already exists", "Okay", null])
			pass
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_save_button_menu_button_pressed(url, other_data):
	#Need to format the string for html
	var string = parser.make_basic(entry.text)
	if string != "":
		emit_signal("save_requested", url, string)
