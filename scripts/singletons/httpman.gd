extends Node

signal response_completed()
signal connection_established()

var pending_connection = false
var pending_request = null

var connected = false

onready var http = HTTPClient.new()


func _ready():
	boot()
	
	
	pass

func boot():
	yield(get_tree().create_timer(0.01), "timeout")
	var result = connect_to("127.0.0.1", 2121)
	if result:
		frontend.go_to("/", "")
		yield(respman, "response_processed")
		popups.close()
		
	else:
		yield(self, "connection_established")
		frontend.go_to("/", "")
		yield(respman, "response_processed")
		popups.close()

func connect_to(ip, port):
	var err = http.connect_to_host(ip, port)
	if err != 0:
		debug.p(["Initial Connection Error: ", err])
		return
	debug.p("Connecting . . .")
	pending_connection = true
	
	return check_connect_status()
		
		
func check_connect_status():
	http.poll()
	var status = http.get_status() 
	if status == HTTPClient.STATUS_CONNECTED:
		debug.p("Connected")
		pending_connection = false
		emit_signal("connection_established")
		return true
		
	elif status == HTTPClient.STATUS_CONNECTING or status == HTTPClient.STATUS_RESOLVING:
		#print("Connecting . . .")
		pass
	
		
		
func send_request(url, ext):
	if ext == null:
		ext = ""
	var out_url = url + ext
	
	if pending_request != null:
		debug.p("Request Rejected: Response in Progress")
		return
		
	var err = http.request(HTTPClient.METHOD_GET, out_url, [])
	if err != 0:
		debug.p(["Request Error: ", err])
		return	
	pending_request = url
		
func send_post(url, ext, post):
	if ext == null:
		ext = ""
	var out_url = url + ext
	
	if pending_request != null:
		debug.p("Request Rejected: Response in Progress")
		return
		
	var err = http.request(HTTPClient.METHOD_POST, out_url, post[0], post[1])
	if err != 0:
		debug.p(["Request Error: ", err])
		return	
	pending_request = url
		
func check_for_response():
	http.poll()
	if http.has_response():
		return true
	return false
	
		
func get_response():
	var headers = http.get_response_headers_as_dictionary()
	debug.p(["code: ", http.get_response_code()])

	if http.is_response_chunked():
		debug.p("Response is chunked!")
	else:
		var bl = http.get_response_body_length()
		debug.p(["Response Length: ", bl])
		
	var data_array = PoolByteArray()
	
	while http.get_status() == HTTPClient.STATUS_BODY:
		http.poll()
		var chunk = http.read_response_body_chunk()
		if chunk.size() == 0:
			#Wait for fill
			OS.delay_usec(1000)
		else:
			data_array = data_array+chunk
	var output = [pending_request, data_array]
	pending_request = null
	return output
		
		
func reconnect():
	http.close()
	connect_to("127.0.0.1", 2121)
	
		
func _process(_delta):
	if pending_connection:
		reconnect()
		#check_connect_status()
	elif pending_request:
		if check_for_response():
			respman.process_response(get_response())
		
		
	pass
