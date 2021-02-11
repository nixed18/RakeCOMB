extends CanvasLayer

var enabled = true

onready var textedit = $TextEdit

func p(text):
	if enabled:
		if typeof(text) == 19:
			text = str(text)
		textedit.text += text+"\n"+"----------\n"
		var length = textedit.text.length()
		if length > 5000:
			textedit.text.erase(0, length-5000)
		textedit.scroll_vertical = INF
	
	
func _process(delta):
	if Input.is_action_just_pressed("debug"):
		textedit.visible = not textedit.visible
		textedit.scroll_vertical = INF
