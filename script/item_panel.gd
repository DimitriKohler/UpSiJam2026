extends Control

var init_position: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO

var draggable: bool = false
var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var snap_offset: Vector2 = Vector2(-15,-45)

var active_panel: Panel = null

@onready var cardboard_panel: Panel = $"../CardboardPanel"
@onready var target_panel: Panel = $"../TargetPanel"
@onready var wrapping_script: Node2D = $"../../../WrappingMinigame"

func _ready():
	reset()

func _gui_input(event):
	if not cardboard_panel.done:
		print("Move cardboard first")
		return
	if not draggable:
		print("Wait for anim to finish")
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if dragging:
				drag_offset = get_global_mouse_position() - global_position
			else:
				_snap_to_target()

	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset


func _process(_delta):
	if dragging:
		_check_targets()

# 🔍 Detect hover target
func _check_targets():
	var mouse_pos = get_global_mouse_position()

	if target_panel.get_global_rect().has_point(mouse_pos):
		target_panel.modulate = Color(1.6,1.6,1.6)
		active_panel = target_panel
	else:
		target_panel.modulate = Color(1,1,1)
		active_panel = null

# 🧲 Snap
func _snap_to_target():
	if active_panel:
		global_position = target_panel.global_position + snap_offset
		target_panel.modulate = Color(1,1,1)
		wrapping_script.instantiate_package()
		cardboard_panel.reset()
		reset()
	else:
		global_position = target_position
		
		
func move_in(duration: float):
	global_position = init_position

	var tween = create_tween()

	tween.parallel().tween_property(self, "global_position", target_position, duration)
	tween.parallel().tween_property(self, "modulate:a", 1.0, duration)
	return await tween.finished


func reset():
	draggable = false
	modulate.a = 0.0
	active_panel = null
	init_position = global_position + Vector2(0, -300)
	target_position = global_position
