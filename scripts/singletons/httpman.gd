extends Node

signal response_completed()
signal connection_established()

var pending_connection = false
var pending_request = null

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
		print("Initial Connection Error: ", err)
		return
		
	pending_connection = true
	
	return check_connect_status()
		
		
func check_connect_status():
	http.poll()
	var status = http.get_status() 
	if status == HTTPClient.STATUS_CONNECTED:
		print("Connected")
		pending_connection = false
		emit_signal("connection_established")
		return true
		
	elif status == HTTPClient.STATUS_CONNECTING or status == HTTPClient.STATUS_RESOLVING:
		print("Connecting . . .")
	
		
		
func send_request(url, ext):
	if ext == null:
		ext = ""
	var out_url = url + ext
	print(out_url)
	
	if pending_request != null:
		print("Request Rejected: Response in Progress")
		return
		
	var err = http.request(HTTPClient.METHOD_GET, out_url, [])
	if err != 0:
		print("Request Error: ", err)
		return	
	pending_request = url
		
func send_post(url, ext, post):
	if ext == null:
		ext = ""
	var out_url = url + ext
	
	if pending_request != null:
		print("Request Rejected: Response in Progress")
		return
		
	var err = http.request(HTTPClient.METHOD_POST, out_url, post[0], post[1])
	if err != 0:
		print("Request Error: ", err)
		return	
	pending_request = url
		
func check_for_response():
	http.poll()
	if http.has_response():
		return true
	return false
	
		
func get_response():
	var headers = http.get_response_headers_as_dictionary()
	print("code: ", http.get_response_code())

	if http.is_response_chunked():
		print("Response is chunked!")
	else:
		var bl = http.get_response_body_length()
		print("Response Length: ", bl)
		
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
		
		
func _process(_delta):
	if pending_connection:
		check_connect_status()
	elif pending_request:
		if check_for_response():
			respman.process_response(get_response())
		
		
	pass
