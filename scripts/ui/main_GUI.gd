extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var content_panel = $content_panel

# Called when the node enters the scene tree for the first time.
func _ready():
	frontend.connect("load_initiated", self, "_on_load_initiated")

func _on_load_initiated(url, content):
	content_panel.display(url, content)


#Nav panel buttons
func _on_home_button_pressed():
	frontend.go_to("/")
	
func _on_wallet_menu_button_pressed(url, other_data):
	frontend.go_to(url)

func _on_save_menu_button_pressed(url, other_data):
	content_panel.display(url, null)
	
func _on_import_menu_button_pressed(url, other_data):
	content_panel.display(url, null)
	
func _on_export_menu_button_pressed(url, other_data):
	frontend.go_to(url, other_data)
	
func _on_shutdown_button_pressed():
	frontend.go_to("/shutdown")
	

#Home buttons
func _on_deciders_purse_menu_button_pressed(url, other_data):
	frontend.go_to(url)

func _on_basic_contract_menu_button_pressed(url, other_data):
	frontend.go_to(url)


#Save buttons
func _on_save_as_save_requested(url, ext):
	frontend.go_to(url, ext)


func _on_home_validate_requested(url, ext):
	frontend.go_to(url, ext)

#Wallet buttons
func _on_wallet_account_button_pressed(url, ext):
	frontend.go_to(url, ext)


#Import Buttons
func _on_import_import_requested(url, other_data):
	frontend.post_to(url, other_data[0], other_data[1])

#Secret Buttons
func _on_secret_sweep_initiated(url, ext):
	frontend.go_to(url, ext)


func _on_confirm_button_menu_button_pressed(url, other_data):
	frontend.go_to(url, other_data)

#Change_add
func _on_change_add_account_button_pressed(url, ext):
	frontend.go_to(url, ext)


func _on_multipay_account_button_pressed(url, ext):
	frontend.go_to(url, ext)

#Export
func _on_export_export_requested(url, ext):
	frontend.go_to(url, ext)

func _on_validator_validator_button_pressed(url, ext):
	frontend.go_to(url, ext)
	print([url, ext])
