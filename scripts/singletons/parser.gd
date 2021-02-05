extends Node

var letters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
var numbers = ["0","1","2","3","4","5","6","7","8","9"]

var homepage_replace = [
	[" Fingerprint of commitment set of size ", "/"],
	[" </p><p>", "/"],
	["</p><p>", "/"],
	[" COMB Tokens in existence as of Bitcoin block ", "/"],
	[" COMB Tokens remaining to be mined after Bitcoin block ", ""],
	["<a href=\"/utxo/bisect/b00667648\">&#128272;", ""],
	["\">&#128272; Validate database integrity with peer</a></p>", "/"],
	["</h1><p>", "/"],
	["<h1>", ""],
	["<p>", ""],
	["<a href=\"/utxo/bisect/b", ""],
	]


# Called when the node enters the scene tree for the first time.
func _ready():
	#print(strip_to("/script", ))
	#print(pull_to("\"", "1235456789\"0000"))
	pass

func is_letter(string):
	var i = 0
	while i < string.length():
		if not letters.has(string[i]):
			return false
		i+=1
	return true
		
func is_basic(string):
	var i = 0
	while i < string.length():
		if not letters.has(string[i]) and not numbers.has(string[i]):
			return false
		i+=1
	return true
	
func make_basic(string):
	var i = 0
	while i < string.length():
		if not letters.has(string[i]) and not numbers.has(string[i]):
			string.erase(i, 1)
		else:
			i+=1
	return string
	

func strip_to_old(target, data):
	var input = data
	var output = String()
	var i = 0
	var ignore = true
	var prev_chars = []
	var target_found = false
	while i < input.length():

		if ignore:
			#Check against target and prev_chars
			prev_chars.append(input[i])
			var x = 0
			while x < prev_chars.size():
				if prev_chars[x] == target[x]:
					target_found = true

				else:
					prev_chars.clear()
					target_found = false
					break
				x+=1
			if target_found and x == target.length():
				ignore = false
		else:
			output+= input[i]
		i+=1
		
	return output
	
func strip_to(target, data):
	var my_string = data
	var i = 0
	var strip = true
	var prev_chars = []
	var target_found = false
	var length = my_string.length()
	while i < length and strip:
		
		#Check against target and prev_chars
		prev_chars.append(my_string[prev_chars.size()])
		var x = 0
		#print([target, prev_chars])
		while x < prev_chars.size():
			if prev_chars[x] == target[x]:
				target_found = true
			else:
				my_string.erase(0, x+1)
				prev_chars.clear()
				target_found = false
				break
			x+=1
		if target_found and x == target.length():
			strip = false
		i+=1
	
	my_string = my_string.lstrip(target)
	
	#print("!!!!!", my_string)
	return my_string
	
func pull_to(target, data):
	var input = data
	var output = String()
	var i = 0
	var prev_chars = []
	var target_found = false
	while i < input.length():
		#Check against target and prev_chars
		prev_chars.append(input[i])
		var x = 0
		while x < prev_chars.size():
			if prev_chars[x] == target[x]:
				target_found = true

			else:
				prev_chars.clear()
				target_found = false
				break
			x+=1
			
		if target_found and x == target.length():
			#Strip the target from the output
			var val = output.length()-(target.length()-1)
		
			output.erase(val, output.length()-val)
			return output

		output+= input[i]
			
		
		i+=1
		
	return output
	
	
#	var run = true
#	var output = String()
#	while run:
#		var x = data[0]
#		if x == target:
#			run = false
#		else:
#			output+=x
#			data.erase(0, 1)
#	return output

func homepage_protocol(data):
	yield(get_tree().create_timer(0.016), "timeout")
	#var output = data.replace("html", "!!!")
	
	var output = strip_to("</script>", data)
	
	var in_sync = true
	#[fingerprint, commit_size, token_total, btc_block, tokens_remaining]
	var values = [String(), String(), String(), String(), String(), String()]

	#Strip irrelevant data
	#Strip everything before <p>

		
	for pair in homepage_replace:
		output = output.replace(pair[0], pair[1])
		
		
	if output[1] == "W":
		#Out of sync
		in_sync = false
		output = output.replace("Wallet appears to be out of sync. Displayed balances are incorrect until wallet is fully synced:/", "")
	
	var i = 0
	while i < values.size():
		var c = output[1]
		if c == "/":
			i+=1
		else:
			values[i] += c
		output.erase(1,1)
	
	values.push_front(in_sync)
	return values

func save_protocol(data):
	yield(get_tree().create_timer(0.016), "timeout")
	var output = strip_to("<br />", data)
	var values#[bool, text]
	
	#Already exists
	if output[0] == "F":
		output = output.replace("</body></html>", "")
		output = output.replace("File or directory already exists: ", "")
		output = output.replace("\n", "")
		values = [false, output]
		
	#Save success
	elif output[0] == "S":
		output = output.replace("</body></html>", "")
		output = output.replace("Saved as: ", "")
		output = output.replace("\n", "")
		values = [true, output]
		pass
	
	else:
		print(output)
		print("!!!UNEXPECTED SAVE CONTENT!!!")
	
	return values

func validate_protocol(data):
	yield(get_tree().create_timer(0.016), "timeout")
	if data[0] == "e":
		print("Validate Error")
		return null
		
	var values = []
	var output = strip_to("now see number <b>", data)

	#Get the bisect_block number
	var bisect_block = pull_to("<", output)
	output = strip_to("<", output)
	values.append(bisect_block)
	
	#Get the rows:
	var rows = []
	var i = 1
	while i <= 16:
		
		#Strip to next row
		var row = [String(), String()]
		output = strip_to("Row "+str(i)+". ", output)
		
		#Pull first number
		row[0] = pull_to(" ", output)
		output = strip_to(" ", output)
				
		#Pull second number
		row[1] = pull_to(" ", output)
		output = strip_to(" ", output)

		rows.append(row)
		#print(output)
			
		i+=1
		
	values.append(rows)
		
	#Get the locator
	output = strip_to("Locator is ", output)
	var locator = pull_to("<", output)
	
	values.append(locator)
	
	#print(values)
	return values
		
func shutdown_protocol(data):
	yield(get_tree().create_timer(0.016), "timeout")
	if "Shutdown successfull" in data:
		get_tree().quit()
	elif "Wallet is not saved" in data:
		return "not_saved"
	else:
		print(data)

func wallet_protocol(data):
	yield(get_tree().create_timer(0.016), "timeout")
	#Figure out how many accounts there are
	#Account pubkeys marks by <tt>
	
	var output = data
	
	#Array of wallet info.
	var values = [] #[pubkey, balance, pay_bool, [[active_spend_url, active_spend_id], [btc_address_that_spent, block_number]]]
	
	var run = true
	while run:
		if "<tt>" in output:
			#Pull pubkey and balance
			#print("~~~~~~~")
			var account_info = [null, null, false, [[String(), String()], [String(), String()]]]
			output = strip_to("<tt>", output)
			account_info[0] = pull_to("<", output)
			output = strip_to(" ", output)
			account_info[1] = pull_to(" ", output)
			
			#print (account_info)
			
			#Check for "pay"
			var pay_check = pull_to("stealth", output)
			if "pay" in pay_check:
				account_info[2] = true
			#print (output)
				
			#Check for more wallets
			if "<tt>" in output:
				#print("TT")
				#If remaining, pull until next tt, and work with that.
				var remaining = pull_to("<tt>", output)
				#print(remaining)
				if "/sign/pay/" in remaining:
					remaining = strip_to("/sign/pay/", remaining)
					account_info[3][0][0] = pull_to(">", remaining)
					account_info[3][0][0] = account_info[3][0][0].replace("\"", "")
					remaining = strip_to(">", remaining)
					
					
					#Pull URL and ID
					if "Active spend " in remaining:
						remaining = strip_to("Active spend ", remaining)
						account_info[3][0][1] = pull_to(" ", remaining)
					else:
						print("Error: No active spend???")
				
					#VVVVVVV>
				#Pull btc address and block number
				if "Spent using " in remaining:
					remaining = strip_to("Spent using ", remaining)
					account_info[3][1][0] = pull_to(" ", remaining)
					remaining = strip_to("at height ", remaining)
					account_info[3][1][1] = pull_to("<", remaining)
					#^^^^^^^^>
			else:
				
				#If not remaining, pull until key gen, and work with that.
				var remaining = pull_to("key generate", output)
				#print(account_info)
				#print(remaining)
				if "/sign/pay/" in remaining:
					remaining = strip_to("/sign/pay/", remaining)
					account_info[3][0][0] = pull_to(">", remaining)
					account_info[3][0][0] = account_info[3][0][0].replace("\"", "")
					remaining = strip_to(">", remaining)
					
					#Pull URL and ID
					if "Active spend " in remaining:
						remaining = strip_to("Active spend ", remaining)
						account_info[3][0][1] = pull_to(" ", remaining)
					else:
						print("Error: No active spend???")
					
				#Pull btc address and block number
				if "Spent using " in remaining:
					remaining = strip_to("Spent using ", remaining)
					account_info[3][1][0] = pull_to(" ", remaining)
					remaining = strip_to("at height ", remaining)
					account_info[3][1][1] = pull_to("<", remaining)
				run = false
				
			values.append(account_info)
			
		else:
			run = false
	#print("~~~~~~~")
#	for value in values:
#		print(value)
#		pass
	return values
	
func stealth_protocol(data):
	yield(get_tree().create_timer(0.016), "timeout")
	var run = true
	var values = [String(), []]#[pubkey, [address arrays]]
	var output = data
	data = ""
	
	#Pull pubkey
	output = strip_to("redirecting to: ", output)
	values[0] = pull_to("</h1>", output)
	
	while run:
		var x = 0
		while x < 500:
			#yield(get_tree().create_timer(0.5), "timeout")
			var info = [String(), String(), String(), String()] #[comb_address, balance, mine_address, sweep_link]
			#Strip to next segment
			output = strip_to("<ul><li> <tt>", output)
			if output == "":
				run = false
				break
				
		#		if output[0] == " ":
		#			output = strip_to("<tt>", output)
			#Pull COMB address
			info[0] = pull_to("</tt>", output)
			output = strip_to(" ", output)
			#Balance
			info[1] = pull_to(" ", output)
			output = strip_to("B ", output)
			
			if output[0] == "(":
				#BTC is viable
				output.erase(0, 1)
				info[2] = pull_to(" ", output)
				output = strip_to(") ", output)
				if output[1] == "a":
					#Sweep ALSO viable
					output = strip_to("stealthdata/", output)
					info[3] = pull_to("\"", output)
				
				
			elif output[1] == "a":
				#BTC not viable, sweep is viable
				output = strip_to("stealthdata/", output)
				info[3] = pull_to("\"", output)
			elif output[1] == "/":
				#btc not viable, sweep not viable
				pass
			
				
				
			#print(info)
			values[1].append(info)
			x+=1
		
		#yield(get_tree().create_timer(0.016), "timeout")

	return(values)
		#Pull segment, if it is valid, continue
		
func import_protocol(data):
	yield(get_tree().create_timer(0.016), "timeout")
	#values = [String(), String(), String(), String(), String()]
	var values = String()
	var output = strip_to("<br />", data)
	if output[0] == "{":
		output = strip_to("{", output)
		values = pull_to("}", output)
	else:
		print("Import Error: ", data)
		
	return values
		 
		

