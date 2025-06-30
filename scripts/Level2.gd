extends Node2D

var player_start_position = Vector2(100, 500)
var collectibles_collected = 0
var total_collectibles = 0
var player = null
var ui_counter = null

func _ready():
	# Get reference to player
	player = get_node_or_null("Player")
	
	# Count total collectibles in the level
	total_collectibles = get_tree().get_nodes_in_group("collectibles").size()
	print("Found ", total_collectibles, " collectibles in the scene")
	
	# Connect to each collectible's 'collected' signal
	for collectible in get_tree().get_nodes_in_group("collectibles"):
		collectible.collected.connect(_on_collectible_collected)
	
	# Create UI counter
	create_ui_counter()
	update_ui()

func create_ui_counter():
	# Create a CanvasLayer for UI elements
	var canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	
	# Create background panel
	var panel = Panel.new()
	panel.position = Vector2(20, 20)
	panel.size = Vector2(200, 60)
	canvas_layer.add_child(panel)
	
	# Create label for counter
	var label = Label.new()
	label.position = Vector2(10, 10)
	label.size = Vector2(180, 40)
	label.text = "Collectibles: 0 / " + str(total_collectibles)
	label.add_theme_font_size_override("font_size", 16)
	panel.add_child(label)
	
	ui_counter = label

func _on_collectible_collected():
	collectibles_collected += 1
	print("Collected collectible! Total: ", collectibles_collected, "/", total_collectibles)
	update_ui()
	
	# Check if all collectibles are collected
	if collectibles_collected >= total_collectibles:
		level_complete()

func update_ui():
	if ui_counter:
		ui_counter.text = "Collectibles: " + str(collectibles_collected) + " / " + str(total_collectibles)

func level_complete():
	print("🎉 LEVEL 2 COMPLETE! All collectibles collected!")
	
	# Create victory message
	create_victory_message()
	
	# Add level completion logic here
	get_tree().change_scene_to_file("res://scenes/HomeScreen.tscn")

func create_victory_message():
	# Create a victory message overlay
	var canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	
	# Create background
	var background = ColorRect.new()
	background.color = Color(0, 0, 0, 0.7)
	background.size = get_viewport().size
	canvas_layer.add_child(background)
	
	# Create victory text
	var victory_label = Label.new()
	victory_label.text = "🎉 LEVEL COMPLETE! 🎉\nAll " + str(total_collectibles) + " collectibles found!"
	victory_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	victory_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	victory_label.size = get_viewport().size
	victory_label.add_theme_font_size_override("font_size", 32)
	victory_label.add_theme_color_override("font_color", Color.YELLOW)
	canvas_layer.add_child(victory_label)

func _on_player_fell():
	# Reset player position if they fall off the level or die
	if player:
		# Reset player position
		player.global_position = player_start_position
		player.velocity = Vector2.ZERO
		player.is_alive = true
		print("Player respawned at start position!") 