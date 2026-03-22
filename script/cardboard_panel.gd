extends Control

var init_position: Vector2 = Vector2.ZERO

var done: bool = false

var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var snap_offset: Vector2 = Vector2(-65,-20)

var active_panel: Panel = null

var glow_tween: Tween

@onready var main_script: Node2D = $"../../../.."
@onready var target_panel: Panel = $"../TargetPanel"

func _ready():
	init_position = global_position
	main_script.current_index_changed.connect(_on_current_index_changed)
	main_script.state_changed.connect(_on_state_changed)
	reset()

func _on_state_changed(new_state):
	pass

func _on_current_index_changed(new_index):
	if new_index == 2:
		start_glow()
	else:
		stop_glow()

# Drag and drop
func _gui_input(event):
	if done:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if dragging:
				$"../../../../AudioStreamPlayer/DragForward".play()
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
		target_panel.modulate = Color(1.5,1.5,1.5)
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
		# Cant reset to keep done true
		active_panel = null
		if main_script.get_current_index() == 2:
			main_script.next()
	else:
		global_position = init_position

func reset():
	visible = true
	done = false
	global_position = init_position
	
func start_glow():
	glow_tween = create_tween().set_loops()
	glow_tween.tween_property(self, "modulate", Color(1.4,1.4,1.4), 0.5)
	glow_tween.tween_property(self, "modulate", Color(1,1,1), 0.5)

func stop_glow():
	if glow_tween:
		glow_tween.kill()
	modulate = Color(1,1,1)
	
