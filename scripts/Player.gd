extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -600.0  # Increased from -400 to -600 (50% higher)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_alive = true
var death_y_position = 800  # Y position where player dies if they fall
var facing_direction = 1  # 1 for right, -1 for left

var jump_sound_player = null
var laser_sound_player = null

func _ready():
	# Add player to the "player" group for collectible detection
	add_to_group("player")
	print("Player added to 'player' group")
	
	# Player is on layer 2, scans for layer 1 (platforms) and layer 4 (enemies)
	collision_layer = 2
	collision_mask = 5  # Can collide with layers 1 (platforms) and 4 (enemies)
	
	print("Player collision layer: ", collision_layer, " mask: ", collision_mask)
	
	# Create simple player sprite
	create_player_sprite()

	# Create audio players
	jump_sound_player = AudioStreamPlayer.new()
	add_child(jump_sound_player)
	laser_sound_player = AudioStreamPlayer.new()
	add_child(laser_sound_player)
	
	# Load sounds
	laser_sound_player.stream = load("res://assets/sounds/laser.mp3")
	jump_sound_player.stream = load("res://assets/sounds/jump.mp3")

func _physics_process(delta):
	if not is_alive:
		return
		
	# Check if player fell off the level
	if global_position.y > death_y_position:
		die()
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		# Play jump sound
		play_jump_sound()

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
		# Update facing direction
		if direction > 0:
			facing_direction = 1
		elif direction < 0:
			facing_direction = -1
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

	# Check for collisions with enemies
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("enemies"):
			die()

func _input(event):
	# Handle shooting
	if event.is_action_pressed("shoot"):
		shoot_laser()

func die():
	is_alive = false
	print("Player died! Starting over...")
	# Notify the level that player died
	get_parent()._on_player_fell()

func play_jump_sound():
	if jump_sound_player and jump_sound_player.stream:
		jump_sound_player.play()
	else:
		print("🔊 Jump sound! (No audio file loaded)")

func shoot_laser():
	# Create a laser projectile
	var laser = Area2D.new()
	laser.add_to_group("lasers")
	
	# Set up collision layers for laser
	laser.collision_layer = 8  # Laser is on layer 8
	laser.collision_mask = 4   # Laser can hit layer 4 (enemies)
	laser.body_entered.connect(func(body):
		if body.is_in_group("enemies"):
			body.die()
		laser.queue_free()
	)
	
	print("Laser created with collision layer: ", laser.collision_layer, " mask: ", laser.collision_mask)
	
	# Add collision shape
	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(20, 4)
	collision_shape.shape = shape
	laser.add_child(collision_shape)
	
	# Add visual representation
	var laser_sprite = ColorRect.new()
	laser_sprite.size = Vector2(20, 4)
	laser_sprite.color = Color.RED
	laser.add_child(laser_sprite)
	
	# Position laser at gun tip
	var gun_offset = Vector2(16, 0) if facing_direction > 0 else Vector2(-16, 0)
	laser.global_position = global_position + gun_offset
	
	# Add to scene
	get_parent().add_child(laser)
	
	# Play laser sound
	play_laser_sound()
	
	# Move laser across the screen
	var screen_width = 1280  # Screen width
	var travel_distance = screen_width * 0.8  # Travel 80% of screen width
	var travel_time = 1.0  # 1 second to travel
	
	var tween = create_tween()
	tween.tween_property(laser, "position", laser.position + Vector2(travel_distance * facing_direction, 0), travel_time)
	tween.tween_callback(laser.queue_free)

func play_laser_sound():
	if laser_sound_player and laser_sound_player.stream:
		laser_sound_player.play()
	else:
		print("💥 Laser sound! (No audio file loaded)")

func create_player_sprite():
	# Create a simple player sprite with ColorRect
	var sprite = ColorRect.new()
	sprite.name = "Sprite2D"
	sprite.size = Vector2(32, 32)
	sprite.color = Color(0.2, 0.6, 1, 1)  # Blue color
	sprite.position = Vector2(-16, -16)  # Center the sprite
	add_child(sprite) 

func _on_body_entered(body):
	print("Player body_entered signal triggered with: ", body.name, " groups: ", body.get_groups())
	if body.is_in_group("enemies"):
		print("Player touched enemy! Player dies!")
		die()
