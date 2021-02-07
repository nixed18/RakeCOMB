extends Node

#Store and manages active account data on RakeCOMB, to make them easier to work with.

#Pubkey : {data} 

#data : balance, active_spend (dict, with status : bool, and othe infor if true)

var accounts = {
	
}


var current_multipay_pubkey = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func store_account(details):
	#[pubkey, balance, pay_bool, [[active_spend_url, active_spend_id], [btc_address_that_spent, block_number]]]
	var account = {}
	accounts[details[0]] = account
	account.balance = details[1]
	account.active_spend = {
		"url" : details[3][0][0], 
		"id" : details[3][0][1], 
		"funder" : details[3][1][0], 
		"block" : details[3][1][1], 
	}
	pass
	
func get_info(pubkey, tag):
	var account = accounts[pubkey]
	if tag == "balance":
		return account.balance
	elif tag == "spend_url":
		return account.active_spend.url
	elif tag == "spend_id":
		return account.active_spend.id
	elif tag == "spend_funder":
		return account.active_spend.funder
	elif tag == "spend_block":
		return account.active_spend.block
