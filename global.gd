extends Node

var money = 50
var round = 0
var inventory = {"Apple": 0, "AppleSapling": 10}
var dialogueDisplayed = false

var dialogues = [[
  {
	"dialogue": "Landlord: Good morning again, Farmer! Today, I'd like to talk to you about sustainable development and production.",
	"options": []
  },
  {
	"dialogue": "Farmer: Good morning! That sounds interesting. What do you mean by sustainable development?",
	"options": []
  },
  {
	"dialogue": "Landlord: Sustainable development means meeting the needs of the present without compromising the ability of future generations to meet their own needs. In farming, this could involve practices that conserve resources and protect the environment.",
	"options": []
  },
  {
	"dialogue": "Farmer: That makes sense. How can I contribute to sustainable development on my farm?",
	"options": []
  },
  {
	"dialogue": "Landlord: One way is by practicing agroforestry, which involves integrating trees into your farm. Trees provide numerous benefits such as preventing soil erosion, improving soil fertility, providing shade for crops, and even generating additional income from timber or fruit production.",
	"options": []
  },
  {
	"dialogue": "Farmer: That sounds promising. I'll start planting more trees on my farm.",
	"options": []
  },
  {
	"dialogue": "Landlord: Great to hear! Now, let's talk about the rent for this month. But before that, here's a little challenge for you.",
	"options": []
  },
  {
	"dialogue": "Landlord: What is the probability of rolling a sum of 7 with two fair six-sided dice?",
	"options": ["1/36", "1/6", "1/69"],
	"correctOptions": "0",
	"correct": ["Correct! Well done, Farmer! As a reward for your quick thinking, I'll give you a discount on your rent this month."],
	"wrong": ["Ah, close but not quite. The correct answer is A) 1/36. No discount this time, but better luck next month."]
  }
]]

var rents = [50, 100, 300]
var optionsDisplayed = false
var currentDialogue = dialogues[round]

func updateInventory(container: VBoxContainer):
	for dictKey in inventory.keys():
		var children = container.get_children(true)
		for child in children:
			if child.name == dictKey:
				for Cchild in child.get_children():
					if Cchild is Label and Cchild.name == "Count":
						Cchild.text = str(inventory.get(dictKey))
