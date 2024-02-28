extends CanvasLayer


func _on_play_button_pressed():
	GameManager.start_game()
	queue_free()


func _on_exit_button_2_pressed():
	GameManager.quit_game()
