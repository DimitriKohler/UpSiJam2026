extends Control

var init_position: Vector2 = Vector2.ZERO

var done: bool = false

var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var snap_offset: Vector2 = Vector2(-15,-45)

var active_panel: Panel = null

@onready var target_panel: Panel = $"../TargetPanel"

func _ready():
	init_position = global_position

func _gui_input(event):
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
		done = true
	else:
		global_position = init_position

func reset():
	done = false
	active_panel = null
	global_position = init_position
	
