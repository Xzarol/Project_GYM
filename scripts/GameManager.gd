extends Node3D

@onready var player_xrorigin_3d: Player = $"../Player_XRORIGIN3D"

var BarbellLabel : Label3D
var DumbbellLabel : Label3D
var KettleBellLabel : Label3D

var Score = {
	"Barbell": 0,
	"Kettlebell": 0,
	"Dumbbell": 0
}

func _ready() -> void:
	
	player_xrorigin_3d.pumped_up.connect(_on_pumping)
	BarbellLabel = player_xrorigin_3d.get_node("LeftHand/LeftHand/BarbellScore")
	DumbbellLabel = player_xrorigin_3d.get_node("LeftHand/LeftHand/DumbbellScore")
	KettleBellLabel = player_xrorigin_3d.get_node("LeftHand/LeftHand/KettleBellScore")
	
	BarbellLabel.text = "Barbell pumped up " + str(Score["Barbell"]) + "/3 times"
	KettleBellLabel.text = "Kettlebell pumped up " + str(Score["Kettlebell"]) + "/5 times"
	DumbbellLabel.text = "Dumbbell pumped up " + str(Score["Dumbbell"]) + "/10 times"
	pass
	
func _on_pumping(Item: String):
	match Item:
		"Barbell":
			if Score["Barbell"] != 3:
				Score["Barbell"] += 1
				BarbellLabel.text = "Barbell pumped up " + str(Score["Barbell"])  + "/3 times"
		"Kettlebell":
			if Score["Kettlebell"] != 5:
				Score["Kettlebell"] += 1
				KettleBellLabel.text = "Kettlebell pumped up " + str(Score["Kettlebell"])  + "/5 times"
		"Dumbbell":
			if Score["Dumbbell"] != 10:
				Score["Dumbbell"] += 1
				DumbbellLabel.text = "Dumbbell pumped up " + str(Score["Dumbbell"])  + "/10 times"
