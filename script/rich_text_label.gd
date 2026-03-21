extends RichTextLabel

@onready var manager = $"../TextManager"

func _ready():
	manager.connect("dialogue_changed", _on_dialogue_changed)
	manager.connect("dialogue_finished", _on_dialogue_finished)
	manager.start()

func _on_dialogue_changed(speaker, text):
	# Format: Alice : Hello...d
	self.text = "%s : %s" % [speaker, text]

func _on_dialogue_finished():
	get_tree().quit()
