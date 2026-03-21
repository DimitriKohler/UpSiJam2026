extends Node2D

@onready var text_manager = $DialogView/TextManager
@onready var dialog_view = $DialogView

@onready var item_data = $MainView/Background/Workbench/ItemPanel/ItemData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_Q:
			get_tree().quit()
		if event.keycode == KEY_D:
			dialog_view.visible = true
			text_manager.next()
		if event.keycode == KEY_W:
			item_data.spawn_item()
			

# TODO Add to score and display it
