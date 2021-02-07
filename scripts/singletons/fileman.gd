extends Node


var d_path = null


# Called when the node enters the scene tree for the first time.
func _ready():
	d_path_setup()


func d_path_setup():
	#print(OS.get_executable_path().get_file())
	if OS.get_executable_path().get_file() == "Godot_v3.2.2-stable_win64.exe":
		d_path = "res://"
	else:
		d_path = OS.get_executable_path().get_base_dir()
	#print(d_path)
