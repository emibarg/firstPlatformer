extends Node
var LEVEL_1 = preload("res://LEVELS/test_levels/level_1.tscn")
var PAUSE_MENU_SCREEN = preload("res://UI/pause_menu_screen.tscn")
var MAIN_MENU_SCREEN = preload("res://UI/main_menu_screen.tscn")
func _ready():
	RenderingServer.set_default_clear_color(Color(0.53, 0, 0.39, 1.00) )
	SettingsManager.load_settings()

func start_game():
	if get_tree().is_paused():
		resume_game()
		return
 
	transition_to_scene(LEVEL_1.resource_path)

func quit_game():
	get_tree().quit()

func pause_game():
	get_tree().paused = true


	var pause_menu_screen_instance = PAUSE_MENU_SCREEN.instantiate()
	get_tree().get_root().add_child(pause_menu_screen_instance)

func resume_game():
	get_tree().paused = false
	

func main_menu():
	var main_menu_screen_instance = MAIN_MENU_SCREEN.instantiate()
	get_tree().get_root().add_child(main_menu_screen_instance)

func transition_to_scene(scene_path):
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(scene_path)
	
