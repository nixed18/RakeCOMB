extends Control

signal response(response)

onready var title = $Panel2/title
onready var shadow = $Panel2/title/shadow

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


func open(details):
	title.text = details
	shadow.text = details
	show()
	

