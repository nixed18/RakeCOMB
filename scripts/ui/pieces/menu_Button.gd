extends Button

signal menu_button_pressed(url, other_data)

export var my_url = "null"
export var other_data = "null"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Button_pressed():
	if my_url != "null":
		emit_signal("menu_button_pressed", my_url, other_data)
