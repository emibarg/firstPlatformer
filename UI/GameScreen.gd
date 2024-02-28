extends CanvasLayer
@onready var colectible_label =  $MarginContainer/VBoxContainer/HBoxContainer/ColectibleLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	ColectibleManager.on_colectible_award_recieved.connect(on_colectible_award_recieved)

func on_colectible_award_recieved(total_award : int):
	colectible_label.text = str(total_award)



func _on_pause_texture_button_pressed():
	GameManager.pause_game()
