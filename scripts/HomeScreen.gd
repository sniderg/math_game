extends Control

func _ready():
	print("HomeScreen loaded successfully!")
	
	# Create the UI programmatically since the scene file isn't working
	create_ui()

func create_ui():
	# Create background
	var background = ColorRect.new()
	background.name = "Background"
	background.color = Color(0.1, 0.1, 0.3, 1)
	background.anchors_preset = Control.PRESET_FULL_RECT
	background.anchor_right = 1.0
	background.anchor_bottom = 1.0
	add_child(background)
	
	# Create title
	var title = Label.new()
	title.name = "Title"
	title.text = "MATH GAME"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	title.anchors_preset = Control.PRESET_CENTER
	title.anchor_left = 0.5
	title.anchor_top = 0.5
	title.anchor_right = 0.5
	title.anchor_bottom = 0.5
	title.offset_left = -200.0
	title.offset_top = -100.0
	title.offset_right = 200.0
	title.offset_bottom = -50.0
	add_child(title)
	
	# Create start button
	var start_button = Button.new()
	start_button.name = "StartButton"
	start_button.text = "START GAME"
	start_button.add_theme_font_size_override("font_size", 24)
	start_button.anchors_preset = Control.PRESET_CENTER
	start_button.anchor_left = 0.5
	start_button.anchor_top = 0.5
	start_button.anchor_right = 0.5
	start_button.anchor_bottom = 0.5
	start_button.offset_left = -100.0
	start_button.offset_top = 50.0
	start_button.offset_right = 100.0
	start_button.offset_bottom = 100.0
	start_button.pressed.connect(_on_start_button_pressed)
	add_child(start_button)
	
	# Create instructions
	var instructions = Label.new()
	instructions.name = "Instructions"
	instructions.text = "Controls:\nWASD or Arrow Keys - Move\nSpace - Jump\nLeft Click - Shoot Laser\n\nCollect all yellow gems while avoiding red enemies!"
	instructions.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	instructions.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	instructions.add_theme_font_size_override("font_size", 16)
	instructions.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8, 1))
	instructions.anchors_preset = Control.PRESET_CENTER
	instructions.anchor_left = 0.5
	instructions.anchor_top = 0.5
	instructions.anchor_right = 0.5
	instructions.anchor_bottom = 0.5
	instructions.offset_left = -300.0
	instructions.offset_top = 150.0
	instructions.offset_right = 300.0
	instructions.offset_bottom = 300.0
	add_child(instructions)
	
	print("UI created programmatically!")
	print("Child nodes:")
	for child in get_children():
		print("  - ", child.name, " (", child.get_class(), ")")
	
	# Set focus on the start button
	start_button.grab_focus()

func _on_start_button_pressed():
	print("Starting game - transitioning to Level 1")
	# Change to Level 1 scene
	get_tree().change_scene_to_file("res://scenes/Level.tscn")
