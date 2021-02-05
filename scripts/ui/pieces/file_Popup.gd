extends Control

signal response(response)

var file_button = preload("res://pieces/file_button.tscn")
var f_ext = "dat"

var selected_path = null
var count_max = 500

var d_path = null


onready var title = $Panel/Panel/title
onready var main = $Panel/Panel/response_text
onready var yes_button = $Panel/HBoxContainer/yes_button
onready var no_button = $Panel/HBoxContainer/no_button
onready var scroll_con = $Panel/Panel2/ScrollContainer
onready var file_holder = $Panel/Panel2/ScrollContainer/file_holder

# Called when the node enters the scene tree for the first time.
func _ready():
	d_path_setup()
	hide()

func d_path_setup():
	#print(OS.get_executable_path().get_file())
	if OS.get_executable_path().get_file() == "Godot_v3.2.2-stable_win64.exe":
		d_path = "res://"
	else:
		d_path = OS.get_executable_path().get_base_dir()
	#print(d_path)
		

func open(details):
	#[title_text, main_text, yes_text, no_text, file_type]
	title.text = details[0]
	main.text = details[1]
	
	if details[2] != null:
		yes_button.text = details[2]
		yes_button.show()
	else:
		yes_button.hide()
		
	if details[3] != null:
		no_button.text = details[3]
		no_button.show()
	else:
		no_button.hide()
		
	pull_files(d_path, f_ext)
	selected_path = null
		
	show()
	
func spawn_button(file_path):
	var new_button = file_button.instance()
	new_button.my_url = file_path
	new_button.text = file_path.get_file()
	new_button.connect("menu_button_pressed", self, "_on_file_button_pressed")
	file_holder.add_child(new_button)

func pull_files(dir_path, file_type, file_reqs=null):
	#clear()
	
	#Format the dir_path
	if not dir_path.ends_with("/"):
		dir_path+="/"
	
	var files = []
	var dir = Directory.new()
	dir.open(dir_path)
	
	dir.list_dir_begin()
	var process = true
	var count = 0
	while process:
		var file = dir.get_next()
		#print(file)
		if file == "":
			#If at the end of the dir, stop
			process = false
		elif not dir.current_is_dir():
			#If the selected file is not a directory, add it to the files list
			#files.append(file)
			#Check reqs if needed
			if file_reqs == null:
				if file.get_extension() == file_type:
					spawn_button(dir_path+file)
					count+=1
					if count > count_max:
						process = false
				
	
	dir.list_dir_end()
	
#	for f in files:
#		if f.get_extension() == file_type:
#			spawn_button(f)
			
	scroll_con.set_v_scroll(0)

func _on_file_button_pressed(url, other_data):
	selected_path = url
	file_chosen()
#	if selected_path == url:
#		file_chosen()
#	else:
#		selected_path = url

func file_chosen():
	emit_signal("response", true, selected_path)
	clear()

func _on_yes_button_menu_button_pressed(url, other_data):
		if selected_path != null:
			file_chosen()
		pass

func _on_no_button_menu_button_pressed(url, other_data):
	emit_signal("response", false, null)
	clear()
	
func clear():
	selected_path = null
	for button in file_holder.get_children():
		button.queue_free()
