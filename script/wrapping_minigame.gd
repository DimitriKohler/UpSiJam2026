extends Node2D

enum WorkState {
	IDLE,
	START_WAITING_FOR_ITEM,
	ITEM_READY,
	ITEM_PLACED,
	CLICKED_ONCE,
	CLICKED_MORE,
	WAITING_COMPLETION,
	END_ITEM_STOLEN,
	END_PACKAGE_SEND,
}

var working: bool = false
var current_work_state = WorkState.IDLE

var clickStrength: int = 1
var difficulty: float = 1.0

@onready var main_script: Node2D = $"../.."
@onready var item_data: Node2D = $"../Background/Workbench/ItemPanel/ItemData"
@onready var cardboard_panel: Panel = $"../Background/Workbench/CardboardPanel"
@onready var item_panel: Panel = $"../Background/Workbench/ItemPanel"
@onready var package_panel: Panel = $"../Background/Workbench/PackagePanel"
@onready var target_panel: Panel = $"../Background/Workbench/TargetPanel"
@onready var money_display: Label = $"../../../../GuiPanel/MoneyLabel"

func _ready():
	main_script.state_changed.connect(_on_state_changed)

func _on_state_changed(new_state):
	if current_work_state == WorkState.IDLE:
		set_work_state(WorkState.START_WAITING_FOR_ITEM)
		await instantiate_item(1.0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_state = main_script.get_state()

	if current_state == main_script.GameState.WORK or current_state == main_script.GameState.TUTO:
		match current_work_state:
			WorkState.IDLE:
				pass
			
			WorkState.START_WAITING_FOR_ITEM:
				pass

			WorkState.ITEM_READY:
				item_panel.draggable = true
				pass

			WorkState.ITEM_PLACED:
				item_panel.draggable = false
				pass

			WorkState.CLICKED_ONCE:
				# Handle CLICKED_ONCE logic here
				pass

			WorkState.CLICKED_MORE:
				# Handle CLICKED_MORE logic here
				pass

			WorkState.WAITING_COMPLETION:
				# Handle WAITING_COMPLETION logic here
				pass

			WorkState.END_ITEM_STOLEN:
				# Handle END_ITEM_STOLEN logic here
				pass

			WorkState.END_PACKAGE_SEND:
				# Handle END_PACKAGE_SEND logic here
				pass

func set_work_state(work_state: WorkState) -> void:
	current_work_state = work_state
	print(" * Work State changed to:", WorkState.keys()[work_state])

func instantiate_item(duration: float):
	item_panel.reset()
	item_data.spawn_item()
	await item_panel.move_in(duration)
	set_work_state(WorkState.ITEM_READY)

func instantiate_package() -> void:
	# TextureRect for sprite
	package_panel.visible = true
	set_work_state(WorkState.ITEM_PLACED)
	
	
