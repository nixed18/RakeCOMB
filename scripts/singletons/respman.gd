extends Node

signal response_processed(data)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
func process_response(response_array):
	#print(response_array)
	#print(response_array[1].get_string_from_utf8())
	
	var type = response_array[0]
	var content = response_array[1].get_string_from_utf8()
	#print(content)
	var output
	
	if type == "/":
		output = yield(parser.homepage_protocol(content), "completed") #[in_sync, fingerprint, commit_size, token_total, btc_block, tokens_remaining]

	elif type == "/export/save/":
		output = yield(parser.save_protocol(content), "completed")
	
	elif type == "/utxo/bisect/b":
		output = yield(parser.validate_protocol(content), "completed")
	
	elif type == "/shutdown":
		output = yield(parser.shutdown_protocol(content), "completed")
		
	elif type == "/wallet/":
		output = yield(parser.wallet_protocol(content), "completed")
	
	elif type == "/wallet/stealth/":
		output = yield(parser.stealth_protocol(content), "completed")
		
	elif type == "/import/":
		output = yield(parser.import_protocol(content), "completed")

		
	emit_signal("response_processed", output)
		

	
	


