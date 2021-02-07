extends HBoxContainer


onready var line = $line_edit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func set_text(text):
	line.text = text
