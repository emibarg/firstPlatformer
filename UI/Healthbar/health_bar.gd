extends Node2D


@export var heart1 : Texture2D
@export var heart0 : Texture2D

@onready var heart1Sprite = $Heart1
@onready var heart2Sprite = $Heart2
@onready var heart3Sprite = $Heart3

func _ready():
	HealthManager.on_health_changed.connect(on_player_health_changed)


func on_player_health_changed(player_current_health : int):
	if player_current_health == 3:
		heart3Sprite.texture = heart1
	elif player_current_health <3 :
		heart3Sprite.texture = heart0
	if player_current_health == 2:
		heart2Sprite.texture = heart1
	elif player_current_health <2 :
		heart2Sprite.texture = heart0
	if player_current_health == 1:
		heart1Sprite.texture = heart1
	elif player_current_health <1 :
		heart1Sprite.texture = heart0