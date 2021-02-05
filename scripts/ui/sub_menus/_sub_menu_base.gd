extends Control


signal launched(content)
signal hidden()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func launch(content_array):
	show()
	emit_signal("launched", content_array)
	
func hidden():
	hide()
	emit_signal("hidden")
	
func return_home():
	frontend.go_to("/")
