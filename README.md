# Laser Game

A 2D platformer game with laser shooting mechanics built with Godot Engine 4.4.

## Features

- **Player Movement**: Smooth left/right movement with jumping mechanics
- **Laser Shooting**: Shoot lasers to defeat enemies
- **Enemy Combat**: Enemies patrol platforms and can be defeated with lasers
- **Death Animation**: Visual feedback when player touches enemies
- **Platform Physics**: Solid platforms with proper collision detection
- **Collectibles**: Rotating collectible items that can be gathered
- **Camera System**: Camera follows the player automatically
- **Level Management**: Multiple levels with transitions
- **Sound Effects**: Jump and laser sound effects
- **Moving Platforms**: Dynamic platforms in level 2

## Controls

- **A/Left Arrow**: Move left
- **D/Right Arrow**: Move right
- **Space/W**: Jump
- **Left Click/X**: Shoot laser

## How to Run

1. **Install Godot Engine 4.4** or later from [godotengine.org](https://godotengine.org/)
2. **Open the project** in Godot Engine
3. **Click the Play button** or press F5 to run the game

## Project Structure

```
math_game/
├── project.godot          # Main project configuration
├── scenes/
│   └── Level.tscn        # Main level scene
├── scripts/
│   ├── Player.gd         # Player movement and physics
│   ├── Level.gd          # Level management
│   └── Collectible.gd    # Collectible item behavior
├── assets/
│   ├── sprites/          # Placeholder for sprite assets
│   └── sounds/           # Placeholder for sound assets
└── icon.svg              # Project icon
```

## Gameplay

- **Objective**: Collect all the yellow collectibles in the level
- **Movement**: Use A/D or arrow keys to move, Space/W to jump
- **Physics**: The game uses realistic gravity and collision detection
- **Completion**: Collect all items to complete the level

## Customization

### Adding New Platforms
1. Open `scenes/Level.tscn` in the Godot editor
2. Add new StaticBody2D nodes under the Platforms section
3. Add CollisionShape2D and visual elements

### Modifying Player Physics
Edit the `scripts/Player.gd` file to adjust:
- `speed`: Movement speed (default: 300)
- `jump_velocity`: Jump strength (default: -400)

### Adding More Collectibles
1. Duplicate existing collectibles in the scene
2. Position them where you want
3. The collection system will automatically detect them

## Development Notes

- Built with Godot 4.4
- Uses CharacterBody2D for player physics
- Implements proper collision layers and groups
- Ready for expansion with sprites, sounds, and additional levels

## Next Steps

To expand this platformer, consider adding:
- Sprite animations for the player
- Sound effects and background music
- Multiple levels
- Enemies and hazards
- Power-ups and special abilities
- UI elements (score, lives, etc.)
