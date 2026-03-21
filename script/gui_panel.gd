extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await fade_out(5.0)
	
func fade_out(duration: float):
	
	modulate.a = 1.0
	var tween = create_tween()

	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	return await tween.finished
