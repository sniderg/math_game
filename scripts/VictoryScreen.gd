extends Control

func _ready():
	print("VictoryScreen loaded successfully!")
	# Create the UI programmatically since the scene file isn't working
	create_ui()

func create_ui():
	# Create background
	var background = ColorRect.new()
	background.name = "Background"
	background.color = Color(0.1, 0.3, 0.1, 1)
	background.anchors_preset = Control.PRESET_FULL_RECT
	background.anchor_right = 1.0
	background.anchor_bottom = 1.0
	add_child(background)
	
	# Create victory title
	var victory_title = Label.new()
	victory_title.name = "VictoryTitle"
	victory_title.text = "🎉 VICTORY! 🎉"
	victory_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	victory_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	victory_title.add_theme_font_size_override("font_size", 48)
	victory_title.add_theme_color_override("font_color", Color(1, 1, 0, 1))
	victory_title.anchors_preset = Control.PRESET_CENTER
	victory_title.anchor_left = 0.5
	victory_title.anchor_top = 0.5
	victory_title.anchor_right = 0.5
	victory_title.anchor_bottom = 0.5
	victory_title.offset_left = -300.0
	victory_title.offset_top = -150.0
	victory_title.offset_right = 300.0
	victory_title.offset_bottom = -100.0
	add_child(victory_title)
	
	# Create victory message
	var victory_message = Label.new()
	victory_message.name = "VictoryMessage"
	victory_message.text = "Congratulations! You've completed both levels!\nYou collected all the gems and defeated all the enemies!"
	victory_message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	victory_message.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	victory_message.add_theme_font_size_override("font_size", 24)
	victory_message.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	victory_message.anchors_preset = Control.PRESET_CENTER
	victory_message.anchor_left = 0.5
	victory_message.anchor_top = 0.5
	victory_message.anchor_right = 0.5
	victory_message.anchor_bottom = 0.5
	victory_message.offset_left = -400.0
	victory_message.offset_top = -50.0
	victory_message.offset_right = 400.0
	victory_message.offset_bottom = 50.0
	add_child(victory_message)
	
	# Create play again button
	var play_again_button = Button.new()
	play_again_button.name = "PlayAgainButton"
	play_again_button.text = "PLAY AGAIN"
	play_again_button.add_theme_font_size_override("font_size", 24)
	play_again_button.anchors_preset = Control.PRESET_CENTER
	play_again_button.anchor_left = 0.5
	play_again_button.anchor_top = 0.5
	play_again_button.anchor_right = 0.5
	play_again_button.anchor_bottom = 0.5
	play_again_button.offset_left = -150.0
	play_again_button.offset_top = 100.0
	play_again_button.offset_right = 150.0
	play_again_button.offset_bottom = 150.0
	play_again_button.pressed.connect(_on_play_again_button_pressed)
	add_child(play_again_button)
	
	# Create new game button
	var new_game_button = Button.new()
	new_game_button.name = "NewGameButton"
	new_game_button.text = "NEW GAME"
	new_game_button.add_theme_font_size_override("font_size", 20)
	new_game_button.anchors_preset = Control.PRESET_CENTER
	new_game_button.anchor_left = 0.5
	new_game_button.anchor_top = 0.5
	new_game_button.anchor_right = 0.5
	new_game_button.anchor_bottom = 0.5
	new_game_button.offset_left = -100.0
	new_game_button.offset_top = 180.0
	new_game_button.offset_right = 100.0
	new_game_button.offset_bottom = 220.0
	new_game_button.pressed.connect(_on_new_game_button_pressed)
	add_child(new_game_button)
	
	print("Victory UI created programmatically!")
	print("Child nodes:")
	for child in get_children():
		print("  - ", child.name, " (", child.get_class(), ")")
	
	# Set focus on the play again button
	play_again_button.grab_focus()

func _on_play_again_button_pressed():
	print("Play again - returning to home screen")
	# Return to home screen
	get_tree().change_scene_to_file("res://scenes/HomeScreen.tscn")

func _on_new_game_button_pressed():
	print("New game - returning to home screen")
	# Return to home screen
	get_tree().change_scene_to_file("res://scenes/HomeScreen.tscn") 