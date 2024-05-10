extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var treeTimer: Timer = Timer.new()
	add_child(treeTimer)
	treeTimer.one_shot = true
	treeTimer.wait_time = 1.0
	treeTimer.connect("timeout", next_round)
	treeTimer.start()

func next_round():
	Global.updateDialogue()
	get_tree().change_scene_to_file("res://world/world.tscn")
