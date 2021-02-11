extends CanvasLayer

signal response(response, data)

var active = null

onready var bg = $ColorRect
onready var types = {
	"text" : $text_Popup,
	"line" : $line_Popup,
	"file_select" : $file_Popup,
	"load" : $load_Popup,
	"recv" : $recv_Popup,
	"valid" : $valid_Popup,
}


# Called when the node enters the scene tree for the first time.
func _ready():
	open("load", "CONNECTING")
	pass

func open(type, details):
	if active == null:
		types[type].open(details)
		active = types[type]
		bg.show()
		
func close():
	if active != null:
		active.hide()
		active = null
		bg.hide()
	

func emit_response(response, data):
	active.hide()
	active = null
	bg.hide()
	emit_signal("response", response, data)


func _on_text_Popup_response(response, data):
	emit_response(response, data)


func _on_line_Popup_response(response, data):
	emit_response(response, data)


func _on_recv_Popup_response(response, data):
	emit_response(response, data)


func _on_valid_Popup_response(response, data):
	emit_response(response, data)
