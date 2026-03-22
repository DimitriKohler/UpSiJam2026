extends Panel

var clickCount: int = 0
var clickTarget: int = 3

var init_position: Vector2 = Vector2.ZERO

var glow_tween: Tween

@onready var main_script: Node2D = $"../../../.."
@onready var item_data: Node2D = $"../ItemPanel/ItemData"
@onready var cardboard_panel: Panel = $"../CardboardPanel"
@onready var item_panel: Panel = $"../ItemPanel"
@onready var money_label: Label = $"../../../MoneyLabel"
@onready var wrapping_script: Node2D = $"../../../WrappingMinigame"
@onready var package_tex_rect: TextureRect = $MarginContainer/Package
@onready var clicker_button: Button = $ClickerButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_position = global_position
	main_script.current_index_changed.connect(_on_current_index_changed)
	main_script.state_changed.connect(_on_state_changed)
	clicker_button.pressed.connect(_on_clicker_pressed)
	reset()
	
func _on_state_changed(new_state):
	pass

func _on_current_index_changed(new_index):
	if new_index == 4:
		start_glow()
		$"../../../../AudioStreamPlayer/DropItem".play()
	else:
		stop_glow()

func _on_clicker_pressed() -> void:
	if not visible:
		return
	
	clicker_button.visible = true
	clickCount += 1

	if clickCount == 1:
		var adhesive_list:=[
			$"../../../../AudioStreamPlayer/Adhesive1",
			$"../../../../AudioStreamPlayer/Adhesive2",
			$"../../../../AudioStreamPlayer/Adhesive3"
		]
		var adhesive = adhesive_list[randi() % adhesive_list.size()]
		adhesive.play()
		item_panel.visible = false
		package_tex_rect.texture = load(item_data.packages[1].sprite_path)

	if clickCount >= 2:
		package_tex_rect.texture = load(item_data.packages[2].sprite_path)
		
	if clickCount >= clickTarget:
		clicker_button.visible = false
		await send_package(Vector2(0, -600), 1.0)
		print("\n * PACKAGE SENT *\n")
		money_label.update_money(0.2)
		if main_script.get_state() == main_script.GameState.WORK:
			main_script.next(0)
		else:
			main_script.next(1)
		reset()
		
func instantiate_package() -> void:
	cardboard_panel.visible = false
	visible = true
	clicker_button.visible = true

func send_package(offset: Vector2, duration: float):
	$"../../../../AudioStreamPlayer/DragAway".play()

	# Calculate target position
	var target_position = global_position + offset

	# Create a tween to move and fade the copy
	var tween = create_tween()
	tween.parallel().tween_property(self, "global_position", target_position, duration)
	tween.parallel().tween_property(self, "modulate:a", 0.0, duration)

	return await tween.finished

func reset():
	global_position = init_position
	clickCount = 0
	visible = false
	package_tex_rect.texture = load(item_data.packages[0].sprite_path)
	
func start_glow():
	glow_tween = create_tween().set_loops()
	glow_tween.tween_property(self, "modulate", Color(1.4,1.4,1.4), 0.5)
	glow_tween.tween_property(self, "modulate", Color(1,1,1), 0.5)

func stop_glow():
	if glow_tween:
		glow_tween.kill()
	modulate = Color(1,1,1)
	
