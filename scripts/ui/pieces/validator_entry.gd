extends PanelContainer

signal row_button_clicked(url_ext)

onready var row = $VBoxContainer/always/row
onready var data1 = $VBoxContainer/always/data1
onready var data2 = $VBoxContainer/always/data2
onready var diff = $VBoxContainer/always/diff
onready var no_data = $VBoxContainer/always/no_data


func setup(info):
	#[rownum, data1num, data2num, locator]
	var locator = info[3]
	if locator.length() <= 9:
		no_data.disabled = true
	else:
		no_data.disabled = false
	row.text = row.text.replace("X", str(info[0]+1))
	data1.text = info[1]
	if info[2] != "":
		data2.show()
		diff.show()
		no_data.show()
		data2.text = info[2]
		diff.other_data = "x"+locator+parser.u16dectohex(info[0])
		no_data.other_data = "n"+locator+parser.u16dectohex(info[0])
	else:
		data2.hide()
		diff.hide()
		no_data.hide()
	

func _on_diff_menu_button_pressed(url, other_data):
	emit_signal("row_button_clicked", url, other_data)

func _on_no_data_menu_button_pressed(url, other_data):
	emit_signal("row_button_clicked", url, other_data)
