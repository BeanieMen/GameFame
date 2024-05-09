extends CanvasLayer

@onready var sapling: Label = get_node("Buy/MarginContainer/VBoxContainer/AppleSapling/Owner")
@onready var apple: Label = get_node("Buy/MarginContainer/VBoxContainer/Apple/Owner")

func _ready():
	sapling.text = "Owned: %s" % Global.inventory["AppleSapling"]
	apple.text = "Owned: %s" % Global.inventory["Apple"]
	
func _on_buy_pressed():
	if Global.money >= 10:
		Global.money -= 10
		Global.inventory["AppleSapling"] += 1
	sapling.text = "Owned: %s" % Global.inventory["AppleSapling"]

func _input(event):
	if event is InputEventKey:
		var key_event = event as InputEventKey
		if key_event.pressed:
			handleKeyInput(key_event)

func handleKeyInput(key_event: InputEventKey) -> void:
	match key_event.unicode:
		0: # esc
			get_tree().change_scene_to_file("res://world/world.tscn")


func _on_sell_pressed():
	if Global.inventory["Apple"] > 0:
		Global.money += 10
		Global.inventory["Apple"] -= 1
	apple.text = "Owned: %s" % Global.inventory["Apple"]
