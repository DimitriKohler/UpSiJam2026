extends Panel

var clickCount: int = 0
var clickTarget: int = 6

@onready var item_data: Node2D = $"../ItemPanel/ItemData"
@onready var wrapping_script: Node2D = $"../../../WrappingMinigame"
@onready var package_tex_rect: TextureRect = $MarginContainer/Package
@onready var debug_label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _gui_input(event: InputEvent) -> void:
	if not visible:
		return
		
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clickCount += wrapping_script.clickStrength
			
			debug_label.text = "Clicks: %d\nTarget: %d\nStrength: %d" % [
				clickCount,
				clickTarget,
				wrapping_script.clickStrength
			]			
			
			if clickCount >= clickTarget / 2:	
				package_tex_rect.texture = load(item_data.packages[1].sprite_path)
			if clickCount >= clickTarget:
				package_tex_rect.texture = load(item_data.packages[2].sprite_path)
				await send_package(Vector2(100, -100), 2.0)
				reset()
			#wrapping_script.call("on_panel_clicked", clickCount)

func send_package(offset: Vector2, duration: float) -> void:
	# Create a copy of the TextureRect
	var sprite_copy = package_tex_rect.duplicate() as TextureRect

	sprite_copy.global_position = package_tex_rect.global_position
	sprite_copy.visible = true
	sprite_copy.modulate.a = 1.0

	# Add it to the same parent as the panel (or any suitable node)
	get_parent().add_child(sprite_copy)

	# Calculate target position
	var target_position = sprite_copy.global_position + offset

	# Create a tween to move and fade the copy
	var tween = create_tween()
	tween.parallel().tween_property(sprite_copy, "global_position", target_position, duration)
	tween.parallel().tween_property(sprite_copy, "modulate:a", 0.0, duration)

	# Wait until tween finishes
	await tween.finished

	# Remove the copy from the scene
	sprite_copy.queue_free()

func reset():
	clickCount = 0
	visible = false
	clickTarget *= wrapping_script.difficulty
	package_tex_rect.texture = load(item_data.packages[0].sprite_path)
