extends Node2D


enum LAYERS {
	soil_data,
	dirt,
	ground,
	crops,
	obstacles,
	tile_selector
}

# Constants for tree and shop positions
const SHOP_POSITION = Vector2i(30, 16)
const TREE_POSITION = Vector2i(40, 5)
const TREE_PLANTING_Y_RANGE = 7
const TREE_TILE_ID = 22

@onready var tilemap: TileMap = get_node("WorldTileMap")
@onready var dice: TextureButton = get_node("Roll")
@onready var MoneyLabel: Label = get_node("CanvasLayer/MoneyLabel")
@onready var player: CharacterBody2D = get_node("PlayerCharacter")
@onready var interact: Label = get_node("CanvasLayer/interactShop")
@onready var interactTree: Label = get_node("CanvasLayer/interactTrees")
@onready var timer: Timer = get_node("RollTimer")
@onready var vbox: VBoxContainer = get_node("CanvasLayer/Inventory/VBoxContainer")
@onready var dialogueBox: TextEdit = get_node("CanvasLayer/Dialogue/DialogueBox")
@onready var dialogueParent: PanelContainer = get_node("CanvasLayer/Dialogue")
@onready var dialogueEnter: Label = get_node("CanvasLayer/DialogueEnter")
@onready var button0: Button = get_node("CanvasLayer/option0")
@onready var button1: Button = get_node("CanvasLayer/option1")
@onready var button2: Button = get_node("CanvasLayer/option2")
@onready var popup: PanelContainer = get_node("CanvasLayer/RoundPopup")
@onready var poor: Label = get_node("CanvasLayer/RoundPopup/Poor")
@onready var rich: Label = get_node("CanvasLayer/RoundPopup/Rich")
@onready var endButton: Button = get_node("CanvasLayer/EndRound")
var optionsDialogue = []
var rng = RandomNumberGenerator.new()
var timer_accumulator = 0.0
var nearShop = false
var treeQueue = []
var canPlant = false
var result = 0
var currentDialogueIndex = -1
var rent = Global.rents.pop_front()
var buttonList
func _ready():
	buttonList = [button0, button1, button2]
	_update_money()
	Global.updateInventory(vbox)

func _process(delta):
	if !timer.is_stopped():
		timer_accumulator += delta
		if timer_accumulator >= 0.1:
			result = rng.randi_range(1, 6)
			dice.texture_normal = load("res://assets/Dice/Side_%s_Pip.png" % result)
			dice.scale = Vector2(0.05, 0.05)
			timer_accumulator = 0

func _input(event):
	if event is InputEventKey:
		var key_event = event as InputEventKey
		if key_event.pressed:
			var player_position_tilemap = tilemap.local_to_map(player.position)
			updateInteractions()
			handleKeyInput(key_event)
			
func updateInteractions() -> void:
	var player_position_tilemap = tilemap.local_to_map(player.position)
	var distance = player_position_tilemap - SHOP_POSITION
	if distance.x > 0 and distance.y > 0:
		interact.visible = true
		nearShop = true
	else:
		interact.visible = false
		nearShop = false
		
	canPlant = player_position_tilemap.x - TREE_POSITION.x > 0 and player_position_tilemap.y < TREE_POSITION.y and Global.inventory["AppleSapling"]  > 0
	interactTree.visible = canPlant

func handleKeyInput(key_event: InputEventKey) -> void:
	match key_event.unicode:
		0:
			if popup.visible == true:
				popup.visible = false
		101: # 'e' key
			if nearShop:
				get_tree().change_scene_to_file("res://ui/Shop.tscn")
		120: # 'x' key
			if canPlant:
				plantTree()

	match key_event.keycode:
		KEY_ENTER:
			if Global.optionsDisplayed == true and optionsDialogue == []:
				pass
			elif optionsDialogue != []:
				dialogueBox.text = optionsDialogue.pop_front()
			else:
				currentDialogueIndex += 1
				if currentDialogueIndex < Global.currentDialogue.size():
					updateDialogueBox()
				else:
					if dialogueBox.text != "":
						var endRoundTimer: Timer = Timer.new()
						add_child(endRoundTimer)
						endRoundTimer.one_shot = true
						endRoundTimer.wait_time = 1.0
						endRoundTimer.connect("timeout", next_round)
						endRoundTimer.start()
					dialogueBox.text = ""
					dialogueParent.visible = false 
					dialogueEnter.visible = false
					Global.optionsDisplayed = false
					for button in buttonList:
						button.visible = false

func plantTree() -> void:
	var treeLocation = TREE_POSITION
	var hasTree = tilemap.get_cell_source_id(LAYERS.obstacles, treeLocation)
	while hasTree == TREE_TILE_ID:
		treeLocation.x += 3
		hasTree = tilemap.get_cell_source_id(LAYERS.obstacles, treeLocation)
	if Global.inventory["AppleSapling"] >= 1 and treeLocation.x < 51:
		Global.inventory["AppleSapling"] =  Global.inventory["AppleSapling"] - 1
		tilemap.set_cell(LAYERS.obstacles, treeLocation, TREE_TILE_ID, Vector2i.ZERO)
		_update_money()
		var treeTimer: Timer = Timer.new()
		add_child(treeTimer)
		treeTimer.one_shot = true
		treeTimer.wait_time = 15.0
		treeTimer.connect("timeout", _on_tree_timeout)
		treeTimer.start()
		Global.updateInventory(vbox)

		treeQueue.push_front(treeLocation)
		
func _on_roll_pressed():
	timer.start()

func _on_roll_timer_timeout():
	result = rng.randi_range(1, 6)
	Global.money += result
	_update_money()
	dice.texture_normal = load("res://assets/Dice/Side_%s_Pip.png" % result)
	dice.scale = Vector2(0.05, 0.05)

func _on_tree_timeout():
	Global.inventory["Apple"] += rng.randi_range(1,3)
	Global.updateInventory(vbox)
	tilemap.set_cell(LAYERS.obstacles, treeQueue.pop_front())
	
func _update_money():
	MoneyLabel.text = "Money: $%s" % Global.money

func start_dialogue():
	dialogueParent.visible = true
	dialogueEnter.visible = true
	currentDialogueIndex = 0
	dialogueBox.text = Global.currentDialogue[0]["dialogue"]

func updateDialogueBox():
	if currentDialogueIndex < Global.currentDialogue.size():
		var dialog = Global.currentDialogue[currentDialogueIndex]
		dialogueBox.text = dialog["dialogue"]
		
		var options = dialog["options"]
		
		if options.size() > 0:
			Global.optionsDisplayed = true
			for i in range(buttonList.size()):
				buttonList[i].visible = true
				buttonList[i].text = options[i]
		else:
			Global.optionsDisplayed = false
		
		for button in buttonList:
			button.visible = options.size() > 0

func option0():
	option_click("0")
func option1():
	option_click("1")
func option2():
	option_click("2")


func _on_end_round_pressed():
	if Global.money >= rent:
		start_dialogue()
		endButton.visible = false

	else:
		popup.visible = true
		poor.visible = true

func option_click(num: String):
	var correctOptions = Global.currentDialogue[currentDialogueIndex]["correctOptions"]
	if correctOptions != num:
		optionsDialogue =  Global.currentDialogue[currentDialogueIndex]["wrong"]
	else:
		optionsDialogue =  Global.currentDialogue[currentDialogueIndex]["correct"]
	dialogueBox.text = optionsDialogue.pop_front()
	for button in buttonList:
		button.visible = false
	Global.optionsDisplayed = false


func next_round():
	get_tree().change_scene_to_file("res://world/intermisson.tscn")
