extends Label

var current_money: float = 0

func _ready():
	_refresh_text()

# Call this to update the money value
func update_money(value: float) -> void:
	current_money += value
	_refresh_text()

func _refresh_text() -> void:
	print(current_money)
	text = "%0.2f$" % current_money
