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
var packages: Array[Item] = []

@onready var item_tex_rect: TextureRect = $"../MarginContainer/Item"

func _ready():
	# Add items
	packages.append(Item.new(ItemType.PACKAGE, "package0"))
	packages.append(Item.new(ItemType.PACKAGE, "package1"))
	packages.append(Item.new(ItemType.PACKAGE, "package2"))
	
	items.append(Item.new(ItemType.USABLE, "redbull"))
	#items.append(Item.new(ItemType.OTHER, "gooddragon"))
	items.append(Item.new(ItemType.USABLE, "pq"))
	items.append(Item.new(ItemType.OTHER, "gtu"))
	items.append(Item.new(ItemType.USABLE, "knife"))
	items.append(Item.new(ItemType.OTHER, "gooddragon"))
	

	## Debug print
	#for i in items:
		#print("Name: %s, Type: %s, Sprite: %s" % [i.name, i.type, i.sprite_path])
		
		
func spawn_item() -> void:
	# Random Item
	var item = items[randi() % items.size()]
	# TextureRect for sprite
	var tex: Texture2D = load(item.sprite_path)
	if tex:
		item_tex_rect.texture = tex
	else:
		push_warning("Sprite not found: %s" % item.sprite_path)
		
