extends Node

# Enum for item types
enum ItemType { PACKAGE, USABLE, OTHER }

# Item class (inner, no class_name)
class Item:
	var type: ItemType
	var name: String
	var sprite_path: String

	func _init(_type: ItemType, _name: String):
		type = _type
		name = _name
		# Assume sprite is in res://sprites/ and name matches file
		sprite_path = "res://visual/sprite/%s.png" % name.to_lower().replace(" ", "_")


# List of items
var items: Array[Item] = []
var package: Item = null

@onready var item_sprite: TextureRect = $"../Item"
@onready var package_sprite: TextureRect = $"../../TargetPanel/Package"
@onready var money_display: Label = $"../../../../GuiPanel/MoneyLabel"

func _ready():
	# Add items
	package = Item.new(ItemType.PACKAGE, "package")
	
	items.append(Item.new(ItemType.USABLE, "redbull"))
	items.append(Item.new(ItemType.OTHER, "gooddragon"))

	# Debug print
	for i in items:
		print("Name: %s, Type: %s, Sprite: %s" % [i.name, i.type, i.sprite_path])
		
		
func spawn_item() -> void:
	# Random Item
	var item = items[randi() % items.size()]
	# TextureRect for sprite
	var tex: Texture2D = load(item.sprite_path)
	if tex:
		item_sprite.texture = tex
	else:
		push_warning("Sprite not found: %s" % item.sprite_path)
		
func spawn_package() -> void:
	# TextureRect for sprite
	package_sprite.modulate.a = 1.0
	
	# Kill previous tween if any (prevents stacking)
	if package_sprite.has_meta("fade_tween"):
		var old_tween = item_sprite.get_meta("fade_tween")
		if old_tween:
			old_tween.kill()

	# Create fade tween
	var tween = create_tween()
	package_sprite.set_meta("fade_tween", tween)

	tween.tween_property(package_sprite, "modulate:a", 0.0, 1.0)
	
	money_display.update_money(0.05)
