extends Panel


onready var sub_menus = {
	"/" : $home,
	"/export/save/" : $save_as,
	"/utxo/bisect/b" : $validator,
	"/wallet/" : $wallet,
	"/wallet/stealth/" : $secret,
	#"/wallet/generator" : $wallet,
	"/import/" : $import,
	"/sign/pay/" : $tx_sign,
	"/sign/from/" : $change_add,
	"/sign/multipay/" : $multipay,
	"/export/index.html" : $export,
	"/export/history/" : $export,
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hide_all():
	for value in sub_menus.values():
		value.hidden()

func display(url, content_array):
	if url == "/wallet/generator":
		frontend.go_to("/wallet/", "")
		return
		
	if url == "/stack/stealthdata/":
		return
		
	if url == "/tx/recv/":
		popups.open("text", ["TX Stored", "Transaction stored successfully\nRemember to save your wallet", "Okay", null])
		return
		
	if url == "/stack/multipaydata/":
		frontend.go_to("/sign/multipay/", content_array)
		
		
	hide_all()
	
	if url == "/shutdown":
		var title = ""
		var main = ""
		if content_array == "not_saved":
			title = "Wallet Not Saved!"
			main = "Please save your wallet before shutting down."
			sub_menus["/export/save/"].launch(null)
			popups.open("text", [title, main, "Okay", null])
		return
		
		
		
		
	if sub_menus.has(url):
		sub_menus[url].launch(content_array)

