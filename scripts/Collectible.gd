extends Area2D

signal collected

@export var collectible_value = 1
@export var rotation_speed = 2.0

var collect_sound_player = null

func _ready():
	# Add to collectibles group
	add_to_group("collectibles")
	print("Collectible added to group at position: ", global_position)
	
	# Collectible is on layer 3, scans for layer 2 (player)
	collision_layer = 3
	collision_mask = 2
	
	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)
	
	print("Collectible collision layer: ", collision_layer, " mask: ", collision_mask)

	# Create audio player
	collect_sound_player = AudioStreamPlayer.new()
	add_child(collect_sound_player)

func _process(delta):
	# Rotate the collectible for visual effect
	rotation += rotation_speed * delta
	
	# Add a floating animation
	var float_offset = sin(Time.get_ticks_msec() * 0.003) * 2.0
	position.y += float_offset * delta

func _on_body_entered(body):
	print("Collectible detected BODY collision with: ", body.name)
	if body.is_in_group("player"):
		print("Player BODY collision detected! Collecting...")
		collect()
	else:
		print("BODY collision with non-player object: ", body.name)

func collect():
	print("Collecting collectible at position: ", global_position)
	# Emit signal to notify level
	emit_signal("collected")
	
	# Play collection effect
	play_collect_sound()
	play_collect_animation()
	
	# Remove the collectible from the scene
	queue_free()

func play_collect_sound():
	if collect_sound_player and collect_sound_player.stream:
		collect_sound_player.play()
	else:
		print("🎵 Collectible collected! (Sound effect)")

func play_collect_animation():
	# Create a simple collection animation
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.1)
	tween.tween_property(self, "scale", Vector2(0, 0), 0.1)
