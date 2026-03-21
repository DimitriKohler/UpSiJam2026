# Made with ChatGPT
extends Node

class_name TextManager

# Each entry: ["Speaker", "Dialogue text"]
var dialogue := [
	["Boss", "Hello [color=red]BBCode injection[/color] (no escaping)!"],
	["Player", "Hey there!"],
	["Boss", "Oh, hello Alice."],
	["Player", "How are you today?"]
]

var current_index := 0

signal dialogue_changed(speaker, text)
signal dialogue_finished

func start():
	current_index = -1
	_emit_current()

func next():
	current_index += 1
	if current_index >= dialogue.size():
		emit_signal("dialogue_finished")
	else:
		_emit_current()

func _emit_current():
	var entry = dialogue[current_index]
	var speaker = entry[0]
	var text = entry[1]
	emit_signal("dialogue_changed", speaker, text)

func is_finished() -> bool:
	return current_index >= dialogue.size()
