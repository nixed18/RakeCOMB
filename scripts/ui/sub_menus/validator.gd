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
