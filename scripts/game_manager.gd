extends Node
@onready var score_label: Label = $Score

var score = 0

func add_point():
	score += 1
	score_label.text = "You collected\n" + str(score) + " coins out of 23!"
