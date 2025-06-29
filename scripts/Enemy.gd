extends CharacterBody2D

@export var speed = 100.0
@export var patrol_distance = 100.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var start_position = Vector2.ZERO
var patrol_direction = 1
var is_alive = true

func _ready():
	# Add to enemies group
	add_to_group("enemies")
	
	# Store starting position for patrol
	start_position = global_position
	
	# Set up collision layers
	collision_layer = 4  # Enemy is on layer 4
	collision_mask = 2   # Enemy can collide with layer 2 (player)
	
	# Create enemy sprite
	create_enemy_sprite()
	
	# Connect collision signals
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	print("Enemy spawned at position: ", global_position)

func _physics_process(delta):
	if not is_alive:
		return
	
	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Simple patrol movement
	var distance_from_start = global_position.x - start_position.x
	
	if distance_from_start > patrol_distance:
		patrol_direction = -1
	elif distance_from_start < -patrol_distance:
		patrol_direction = 1
	
	velocity.x = speed * patrol_direction
	
	move_and_slide()

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Enemy touched player! Player dies!")
		body.die()

func _on_area_entered(area):
	if area.is_in_group("lasers"):
		print("Enemy hit by laser! Enemy dies!")
		die()

func die():
	is_alive = false
	print("Enemy died at position: ", global_position)
	
	# Play death animation
	play_death_animation()
	
	# Remove from scene
	queue_free()

func play_death_animation():
	# Create a simple death animation
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.1)
	tween.tween_property(self, "scale", Vector2(0, 0), 0.1)
	tween.tween_callback(print.bind("💀 Enemy destroyed!"))

func create_enemy_sprite():
	# Create a simple enemy sprite with ColorRect
	var sprite = ColorRect.new()
	sprite.name = "Sprite2D"
	sprite.size = Vector2(24, 24)
	sprite.color = Color(1, 0, 0, 1)  # Red color for enemies
	sprite.position = Vector2(-12, -12)  # Center the sprite
	add_child(sprite) 