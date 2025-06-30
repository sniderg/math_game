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
	
	# Create collision shape for player
	var collision_shape = CollisionShape2D.new()
	collision_shape.name = "CollisionShape2D"
	var shape = RectangleShape2D.new()
	shape.size = Vector2(20, 35)  # Adjusted to match new character size
	collision_shape.shape = shape
	collision_shape.position = Vector2(0, -5)  # Adjusted position to match sprite
	add_child(collision_shape)
	
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
		# Update character sprite direction
		update_character_direction()
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
	print("Player died! Starting death animation...")
	
	# Get the sprite container for animation
	var sprite_container = get_node_or_null("Sprite2D")
	if sprite_container:
		# Create death animation
		var tween = create_tween()
		
		# Flash red and shrink
		tween.parallel().tween_property(sprite_container, "modulate", Color.RED, 0.1)
		tween.parallel().tween_property(sprite_container, "scale", Vector2(0.5, 0.5), 0.2)
		
		# Fade out after shrinking
		tween.tween_property(sprite_container, "modulate", Color.TRANSPARENT, 0.2)
		
		# Wait for animation to complete, then respawn
		tween.tween_callback(func():
			print("Death animation complete, respawning...")
			# Reset sprite properties
			sprite_container.modulate = Color.WHITE
			sprite_container.scale = Vector2(1, 1)
			# Notify the level that player died
			get_parent()._on_player_fell()
		)
	else:
		# Fallback if sprite not found
		print("Death animation complete, respawning...")
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
	
	# Add visual representation
	var laser_sprite = ColorRect.new()
	laser_sprite.size = Vector2(20, 4)
	laser_sprite.color = Color.RED
	laser.add_child(laser_sprite)
	
	# Add collision shape for laser
	var laser_collision = CollisionShape2D.new()
	var laser_shape = RectangleShape2D.new()
	laser_shape.size = Vector2(20, 4)
	laser_collision.shape = laser_shape
	laser.add_child(laser_collision)
	
	# Position laser at gun tip
	var gun_offset = Vector2(16, -7) if facing_direction > 0 else Vector2(-16, -7)
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
	# Create a container for the player sprite
	var sprite_container = Node2D.new()
	sprite_container.name = "Sprite2D"
	# Move the sprite container up so the feet are at the bottom
	sprite_container.position = Vector2(0, -10)
	add_child(sprite_container)
	
	# Create body (torso) - shorter
	var body = ColorRect.new()
	body.name = "Body"
	body.size = Vector2(20, 18)  # Shorter body
	body.color = Color(0.2, 0.6, 1, 1)  # Blue body
	body.position = Vector2(-10, -9)
	sprite_container.add_child(body)
	
	# Create head - smaller
	var head = ColorRect.new()
	head.name = "Head"
	head.size = Vector2(14, 14)  # Smaller head
	head.color = Color(0.9, 0.7, 0.5, 1)  # Skin color
	head.position = Vector2(-7, -16)
	sprite_container.add_child(head)
	
	# Create eyes
	var left_eye = ColorRect.new()
	left_eye.name = "LeftEye"
	left_eye.size = Vector2(2, 2)
	left_eye.color = Color(0, 0, 0, 1)  # Black eyes
	left_eye.position = Vector2(-5, -15)
	sprite_container.add_child(left_eye)
	
	var right_eye = ColorRect.new()
	right_eye.name = "RightEye"
	right_eye.size = Vector2(2, 2)
	right_eye.color = Color(0, 0, 0, 1)  # Black eyes
	right_eye.position = Vector2(-1, -15)
	sprite_container.add_child(right_eye)
	
	# Create arms - shorter
	var left_arm = ColorRect.new()
	left_arm.name = "LeftArm"
	left_arm.size = Vector2(5, 12)  # Shorter arms
	left_arm.color = Color(0.2, 0.6, 1, 1)  # Blue arms
	left_arm.position = Vector2(-15, -6)
	sprite_container.add_child(left_arm)
	
	var right_arm = ColorRect.new()
	right_arm.name = "RightArm"
	right_arm.size = Vector2(5, 12)  # Shorter arms
	right_arm.color = Color(0.2, 0.6, 1, 1)  # Blue arms
	right_arm.position = Vector2(10, -6)
	sprite_container.add_child(right_arm)
	
	# Create laser gun on right arm - more pronounced
	var laser_gun = ColorRect.new()
	laser_gun.name = "LaserGun"
	laser_gun.size = Vector2(14, 8)  # Bigger gun
	laser_gun.color = Color(0.2, 0.2, 0.2, 1)  # Darker gun
	laser_gun.position = Vector2(15, -7)
	sprite_container.add_child(laser_gun)
	
	# Create gun barrel - more pronounced
	var gun_barrel = ColorRect.new()
	gun_barrel.name = "GunBarrel"
	gun_barrel.size = Vector2(10, 3)  # Bigger barrel
	gun_barrel.color = Color(0.1, 0.1, 0.1, 1)  # Darker barrel
	gun_barrel.position = Vector2(29, -6)
	sprite_container.add_child(gun_barrel)
	
	# Create gun grip
	var gun_grip = ColorRect.new()
	gun_grip.name = "GunGrip"
	gun_grip.size = Vector2(4, 8)  # Gun grip
	gun_grip.color = Color(0.4, 0.4, 0.4, 1)  # Lighter grip
	gun_grip.position = Vector2(17, -2)
	sprite_container.add_child(gun_grip)
	
	# Create gun sight
	var gun_sight = ColorRect.new()
	gun_sight.name = "GunSight"
	gun_sight.size = Vector2(2, 2)  # Gun sight
	gun_sight.color = Color(1, 0, 0, 1)  # Red sight
	gun_sight.position = Vector2(20, -8)
	sprite_container.add_child(gun_sight)
	
	# Create legs - much shorter
	var left_leg = ColorRect.new()
	left_leg.name = "LeftLeg"
	left_leg.size = Vector2(7, 8)  # Much shorter legs
	left_leg.color = Color(0.1, 0.3, 0.8, 1)  # Darker blue legs
	left_leg.position = Vector2(-8, 9)
	sprite_container.add_child(left_leg)
	
	var right_leg = ColorRect.new()
	right_leg.name = "RightLeg"
	right_leg.size = Vector2(7, 8)  # Much shorter legs
	right_leg.color = Color(0.1, 0.3, 0.8, 1)  # Darker blue legs
	right_leg.position = Vector2(1, 9)
	sprite_container.add_child(right_leg)
	
	# Create feet - positioned at ground level
	var left_foot = ColorRect.new()
	left_foot.name = "LeftFoot"
	left_foot.size = Vector2(8, 3)  # Smaller feet
	left_foot.color = Color(0.2, 0.2, 0.2, 1)  # Dark gray feet
	left_foot.position = Vector2(-9, 17)  # At ground level
	sprite_container.add_child(left_foot)
	
	var right_foot = ColorRect.new()
	right_foot.name = "RightFoot"
	right_foot.size = Vector2(8, 3)  # Smaller feet
	right_foot.color = Color(0.2, 0.2, 0.2, 1)  # Dark gray feet
	right_foot.position = Vector2(1, 17)  # At ground level
	sprite_container.add_child(right_foot)

func update_character_direction():
	# Get the sprite container
	var sprite_container = get_node_or_null("Sprite2D")
	if not sprite_container:
		return
	
	# Flip the character based on facing direction
	if facing_direction > 0:
		# Facing right - normal scale
		sprite_container.scale.x = 1
	else:
		# Facing left - flip horizontally
		sprite_container.scale.x = -1

func _on_body_entered(body):
	print("Player body_entered signal triggered with: ", body.name, " groups: ", body.get_groups())
	if body.is_in_group("enemies"):
		print("Player touched enemy! Player dies!")
		die()
