
extends Node2D

# 🎮 Game states
enum GameState {
	DEFAULT,
	DIALOG,
	TUTO,
	WORK
}

var state_list := [
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.TUTO,
	GameState.TUTO,
	GameState.TUTO,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG,
	GameState.DIALOG	
]  

var count_list := [
	
]


var current_state: GameState = GameState.DEFAULT
var current_index: int = -1

signal state_changed(new_state: GameState)
signal current_index_changed(new_index: int)

@onready var disclaimer_panel = $MainView/DisclaimerPanel
@onready var disclaimer_label = $MainView/DisclaimerPanel/DisclaimerLabel
@onready var money_label = $MainView/MoneyLabel
@onready var text_manager = $DialogView/TextManager
@onready var dialog_view = $DialogView
@onready var item_data = $MainView/Background/Workbench/ItemPanel/ItemData

func _ready():
	await intro()
	money_label.visible = true
	next()


func _process(delta: float) -> void:
	pass


func next(increment: int = 1):
	_set_index(current_index + increment)
	_set_state(state_list[current_index])
	
	
func _set_index(new_index: int) -> void:
	if current_index == new_index:
		return
		
	current_index = new_index
	emit_signal("current_index_changed", new_index)
	print("Current index changed to:", new_index)
	
	
func get_current_index() -> int:
	return current_index
	
func _set_state(new_state: GameState) -> void:
	if current_state == new_state:
		return

	current_state = new_state
	emit_signal("state_changed", new_state)
	print("Game State changed to:", GameState.keys()[new_state])

	# Optional: react immediately on state change
	# ...

func get_state() -> GameState:
	return current_state
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_Q or event.keycode == KEY_ESCAPE:
			get_tree().quit()
		


func intro() -> void:
	# Start hidden
	disclaimer_panel.visible = true
	disclaimer_panel.modulate.a = 1.0
	
	disclaimer_label.visible = true
	disclaimer_label.modulate.a = 0.0

	# --- Fade IN text ---
	var tween = create_tween()
	tween.tween_property(disclaimer_label, "modulate:a", 1.0, 0.0)
	await tween.finished

	# Small pause (optional)
	await get_tree().create_timer(0.0).timeout

	# --- Fade OUT text ---
	tween = create_tween()
	tween.tween_property(disclaimer_label, "modulate:a", 0.0, 0.0)
	await tween.finished

	# --- Fade OUT background ---
	tween = create_tween()
	tween.tween_property(disclaimer_panel, "modulate:a", 0.0, 0.5)
	await tween.finished

	# Hide everything at the end
	disclaimer_panel.visible = false
	disclaimer_label.visible = false
