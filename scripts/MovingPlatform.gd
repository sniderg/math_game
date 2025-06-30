extends AnimatableBody2D

@export var move_distance = 200.0
@export var move_duration = 2.0

func _ready():
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_loops()
	tween.tween_property(self, "position", position + Vector2(0, -move_distance), move_duration)
	tween.tween_property(self, "position", position, move_duration)
