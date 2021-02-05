extends Node

signal transition_finished(url)

onready var lock_screen = $lock_screen

func lock_screen(onoff):
	lock_screen.visible = onoff

func to(url, ext):
	var data = null
	#Disable clicking
	lock_screen(true)
	#popups.open("load", "LOADING")
	#yield(get_tree().create_timer(0.01), "timeout")
	
	
	httpman.send_request(url, ext)
	data = yield(respman, "response_processed")
	#print(data)
		
	#Wait
	lock_screen(false)
	#popups.close()
	
	emit_signal("transition_finished", url, data)

func post(url, ext, content):
	var data = null
	lock_screen(true)
	httpman.send_post(url, ext, httppost_formatter.format_import(content))
	data = yield(respman, "response_processed")
	lock_screen(false)
	emit_signal("transition_finished", url, data)
