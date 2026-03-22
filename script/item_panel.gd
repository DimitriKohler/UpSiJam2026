extends Control

var init_position: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO

var draggable: bool = false
var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var snap_offset: Vector2 = Vector2(45,55)

var active_panel: Panel = null

var glow_tween: Tween

@onready var main_script: Node2D = $"../../../.."
@onready var cardboard_panel: Panel = $"../CardboardPanel"
@onready var target_panel: Panel = $"../TargetPanel"
@onready var wrapping_script: Node2D = $"../../../WrappingMinigame"


func _ready():
	main_script.current_index_changed.connect(_on_current_index_changed)
	main_script.state_changed.connect(_on_state_changed)
	reset()

func _on_state_changed(new_state):
	pass

func _on_current_index_changed(new_index):
	if new_index == 3:
		start_glow()
	else:
		stop_glow()

func _gui_input(event):
	if not cardboard_panel.done:
		return
	if not draggable:
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
		target_panel.modulate = Color(1.5,1.5,1.5)
		active_panel = target_panel
	else:
		target_panel.modulate = Color(1,1,1)
		active_panel = null

# 🧲 Snap
func _snap_to_target():
	if active_panel:
		global_position = target_panel.global_position + snap_offset
		scale = Vector2(0.5,0.5)
		target_panel.modulate = Color(1,1,1)
		wrapping_script.instantiate_package()
		target_panel.visible = false
		draggable = false
		# reset()
		if main_script.get_current_index() == 3:
			main_script.next()
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
	scale = Vector2.ONE
	modulate.a = 0.0
	active_panel = null
	init_position = global_position + Vector2(0, -400)
	target_position = global_position
	
func start_glow():
	glow_tween = create_tween().set_loops()
	glow_tween.tween_property(self, "modulate", Color(1.4,1.4,1.4), 0.5)
	glow_tween.tween_property(self, "modulate", Color(1,1,1), 0.5)

func stop_glow():
	if glow_tween:
		glow_tween.kill()
	modulate = Color(1,1,1)
