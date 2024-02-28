extends Node


static var total_award_amount : int
signal on_colectible_award_recieved


func give_pickup_award(colectible_award : int):
	total_award_amount += colectible_award
	on_colectible_award_recieved.emit(total_award_amount)
