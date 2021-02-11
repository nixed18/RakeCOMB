extends Node


signal load_initiated(url, content)


func _ready():
	transition.connect("transition_finished", self, "_on_transition_finished")

func _on_transition_finished(url, content):
	emit_signal("load_initiated", url, content)

func go_to(url, ext=""):
	transition.to(url, ext)
#	if url == "/":
#		transition.to("/")

func post_to(url, ext, content):
	transition.post(url, ext, content)
	
