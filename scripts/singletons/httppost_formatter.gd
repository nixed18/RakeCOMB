extends Node

func _ready():
	#print(format_import("file1.dat"))
	pass

func format_import(file_name):
	var file = File.new()
	file.open(file_name, File.READ)
	var file_content = file.get_buffer(file.get_len())
	
	var file_part = "Content-Disposition: form-data; name=\"fileToUpload\"; id=\""+file_name+"\"\r\n"
	
	var body = PoolByteArray()
	body.append_array("\r\n--45764mYhAiRcOmB047917328j38dj\r\n".to_utf8())
	body.append_array(file_part.to_utf8())
	body.append_array("Content-Type: text/plain\r\n\r\n".to_utf8())
	body.append_array(file_content)
#	body.append_array("\r\n--45764mYhAiRcOmB047917328j38dj\r\n".to_utf8())
#	body.append_array("Content-Disposition: form-data; value=\"Load Coin History\"; name=\"submit\"\r\n")
	
	
	body.append_array("\r\n--45764mYhAiRcOmB047917328j38dj--\r\n".to_utf8())#End
	
	#print(body.get_string_from_utf8())

	var headers = [
		"Content-Type: multipart/form-data;boundary=\"45764mYhAiRcOmB047917328j38dj\""
	]
	
	return [headers, body.get_string_from_utf8()]

	pass
