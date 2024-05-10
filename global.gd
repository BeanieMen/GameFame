extends Node

var money = 100
var round = 0
var inventory = {"Apple": 0, "AppleSapling": 10}
var dialogueDisplayed = false
var discounts = [20,30,35]
var questions = [3,1]

var dialogue1 = [[
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
	"correctOptions": "1",
	"correct": ["Correct! Well done, Farmer! Heres a further discount of 10%"],
	"wrong": ["Ah, close but not quite. The correct answer is A) 1/36. No discount this time, but better luck next month."]
  }], [
	{
		"dialogue": "Landlord: Alright, let's spice things up a bit.",
		"options": []
	},
	{
	"dialogue": "In a well-shuffled standard deck of playing cards, what is the probability of drawing a red card from the top of the deck on the second draw, given that the first draw resulted in drawing a black card?",
	"options": ["1/2", "26/51", "1/3"],
	"correctOptions": "1",
	"correct": ["Brilliant! You're spot on! Heres a further discount of 10%"],
	"wrong": ["Close, but not quite. The correct answer is B) 26/51. Keep at it, you're making progress!"]
	}],
	[{
		"dialogue": "Ok, Lets try a harder question",
		"options": []
	},
	{
	"dialogue": "What is the probability of drawing a red card from a standard deck of playing cards?",
	"options": ["1/2", "1/4", "1/3"],
	"correctOptions": "0",
	"correct": ["Well done! You're absolutely correct! Heres a further discount of 10%"],
	"wrong": ["Not quite. The correct answer is A) 1/2 Keep practicing, you'll get it next time!"]
}]]



var dialogue2 = [[
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
	"correctOptions": "1",
	"correct": ["Correct! Well done, Farmer! Heres a discount of 10%"],
	"wrong": ["Ah, close but not quite. The correct answer is B) 1/6. No discount this time, but better luck next month."]
  }], [
	{
		"dialogue": "Landlord: Alright, let's spice things up a bit.",
		"options": []
	},
	{
	"dialogue": "In a well-shuffled standard deck of playing cards, what is the probability of drawing a red card from the top of the deck on the second draw, given that the first draw resulted in drawing a black card?",
	"options": ["1/2", "26/51", "1/3"],
	"correctOptions": "1",
	"correct": ["Brilliant! You're spot on! Heres a further discount of 10%"],
	"wrong": ["Close, but not quite. The correct answer is B) 26/51. Keep at it, you're making progress!"]
	}],
	[{
		"dialogue": "Ok, Lets try a harder question",
		"options": []
	},
	{
	"dialogue": "What is the probability of drawing a red card from a standard deck of playing cards?",
	"options": ["1/2", "1/4", "1/3"],
	"correctOptions": "0",
	"correct": ["Well done! You're absolutely correct! Heres a further discount of 10%"],
	"wrong": ["Not quite. The correct answer is A) 1/2 Keep practicing, you'll get it next time!"]
}]]

var rents = [100, 100, 100]
var optionsDisplayed = false
var currentDialogue = dialogue1[0]


func updateInventory(container: VBoxContainer):
	for dictKey in inventory.keys():
		var children = container.get_children(true)
		for child in children:
			if child.name == dictKey:
				for Cchild in child.get_children():
					if Cchild is Label and Cchild.name == "Count":
						Cchild.text = str(inventory.get(dictKey))

func updateDialogue():
	round+=1
	match round:
		0:
			currentDialogue = dialogue1[0]
		1:
			currentDialogue = dialogue2[0]
	
