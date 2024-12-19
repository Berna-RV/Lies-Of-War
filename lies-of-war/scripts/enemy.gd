extends CharacterBody2D

const SPEED = 50.0

var NUMBER_OF_SOLDIERS = 50

var in_pursuit = false
var player_army = null

var animation_state = "idle"

func enemy():
	pass

func _ready() -> void:
	$number_of_soldiers.text = str(NUMBER_OF_SOLDIERS)

func _physics_process(delta: float) -> void:
	if in_pursuit and player_army != null:
		animation_state = "walk"
		var direction = (player_army.position - position).normalized()
		velocity = direction * SPEED
		
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				$AnimatedSprite2D.play("walk_right")
			else:
				$AnimatedSprite2D.play("walk_left")
		else:
			if direction.y > 0:
				$AnimatedSprite2D.play("walk_down")
			else:
				$AnimatedSprite2D.play("walk_up")
	else:
		velocity = Vector2.ZERO
		if animation_state != "idle":
			animation_state = "idle"
			$AnimatedSprite2D.stop()
			
	move_and_slide()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("army"):
		player_army = body
		in_pursuit = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("army"):
		player_army = null
		in_pursuit = false

func defeat():
	$battle_timer.start()
	
func in_battle():
	in_pursuit=false
	animation_state = "idle"
	$AnimatedSprite2D.stop()

func _on_battle_timer_timeout() -> void:
	queue_free()

func update_number_of_soldiers(number):
	NUMBER_OF_SOLDIERS = number
	$number_of_soldiers.text = str(NUMBER_OF_SOLDIERS)
	
	
