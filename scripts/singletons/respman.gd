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
	#I know this is sub-optimal, shutup
	if type == "/":
		output = parser.homepage_protocol(content)#[in_sync, fingerprint, commit_size, token_total, btc_block, tokens_remaining]

	elif type == "/export/save/":
		output = parser.save_protocol(content)
	
	elif type == "/utxo/bisect/":
		output = parser.validate_protocol(content)
	
	elif type == "/shutdown":
		output = parser.shutdown_protocol(content)
		
	elif type == "/wallet/":
		output = parser.wallet_protocol(content)
	
	elif type == "/wallet/stealth/":
		#print("!!!")
		#print(OS.get_ticks_msec())
		output = parser.stealth_protocol(content)
		#print(OS.get_ticks_msec())
		
	elif type == "/import/":
		output = parser.import_protocol(content)
		
	elif type == "/sign/pay/":
		output = parser.txsign_protocol(content)
		
	elif type == "/tx/recv/":
		output = parser.txrecv_protocol(content)
		
	elif type == "/sign/from/":
		output = parser.change_protocol(content)
	
	elif type == "/sign/multipay/":
		output = parser.multipay_protocol(content)
	
	elif type == "/stack/multipaydata/":
		output = parser.multipaydata_protocol(content)
		
	elif type == "/export/history/":
		output = content

		
	emit_signal("response_processed", output)
		

	
	


