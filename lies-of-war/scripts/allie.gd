extends CharacterBody2D

const NUMBER_OF_SOLDIER = 100

func _ready() -> void:
	$number_of_soldiers.text= str(NUMBER_OF_SOLDIER)
	
func allie():
	pass
	
func absorved():
	queue_free()
