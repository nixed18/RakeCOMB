extends Control

signal response(response)

onready var title = $Panel2/title
onready var shadow = $Panel2/title/shadow
onready var animated_sprite = $ColorRect/Control/AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


func open(details):
	animated_sprite.play("default")
	title.text = details
	shadow.text = details
	show()
	

