extends Tabs


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Favs_pressed():
	if $Others/Content.visible == true:
		$Others/Content.visible = false
		$Favs/Content.visible = true


func _on_Others_pressed():
	if $Favs/Content.visible == true:
		$Favs/Content.visible = false
		$Others/Content.visible = true
