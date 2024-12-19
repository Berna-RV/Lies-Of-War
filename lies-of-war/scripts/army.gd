extends CharacterBody2D

var NUMBER_OF_SOLDIERS = 100
const SPEED = 100.0
var click_position = Vector2()
var target_position = Vector2()

var is_in_battle = false
var enemy_army = null
var allie_army = null

@onready var animated_sprite = $AnimatedSprite2D

# identifier method
func army():
	pass

func _ready() -> void:
	$number_of_soldiers.text = str(NUMBER_OF_SOLDIERS)
	
func _physics_process(delta: float) -> void:
	if !is_in_battle:
		if Input.is_action_just_pressed("move"):
			click_position = get_global_mouse_position()
		
		if position.distance_to(click_position) > 3:
			target_position = (click_position - position).normalized()
			velocity = target_position * SPEED
			play_movement_animation() # Play the appropriate movement animation
		else:
			velocity = Vector2() # Stop movement when close enough
			animated_sprite.stop()
	else:
		# Ensure velocity is zero when in battle
		velocity = Vector2.ZERO 
		animated_sprite.stop()
	
	move_and_slide()

func play_movement_animation():
	if abs(target_position.x) > abs(target_position.y):
		if target_position.x > 0:
			animated_sprite.play("walk_right") # Replace with your actual animation name
		else:
			animated_sprite.play("walk_left")
	else:
		if target_position.y > 0:
			animated_sprite.play("walk_down")
		else:
			animated_sprite.play("walk_up")
			
func attack(enemy_position):
	if abs(target_position.x) > abs(target_position.y):
		if target_position.x > 0:
			animated_sprite.play("walk_right") # Replace with your actual animation name
		else:
			animated_sprite.play("walk_left")
	else:
		if target_position.y > 0:
			animated_sprite.play("walk_down")
		else:
			animated_sprite.play("walk_up")
			
func defeat():
	$battle_timer.start()

func _on_battle_area_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		# Stop movement immediately
		velocity = Vector2.ZERO
		click_position = position # Reset click position to current position
		
		animated_sprite.stop()
		enemy_army = body
		is_in_battle = true
		fight()
	elif body.has_method("allie"):
		print("is an allie")
		allie_army = body
		is_in_battle = true
		velocity = Vector2.ZERO
		click_position = position # Reset click position to current position
		concat_armies()

func concat_armies():
	if allie_army != null:
		print("concat armies")
		NUMBER_OF_SOLDIERS = NUMBER_OF_SOLDIERS + allie_army.NUMBER_OF_SOLDIER
		allie_army.absorved()
		$number_of_soldiers.text = str(NUMBER_OF_SOLDIERS)
		allie_army = null
		is_in_battle = false

func fight():
	if enemy_army != null:
		print("battle started")
		enemy_army.in_battle()
		if NUMBER_OF_SOLDIERS>enemy_army.NUMBER_OF_SOLDIERS:
			NUMBER_OF_SOLDIERS = NUMBER_OF_SOLDIERS - enemy_army.NUMBER_OF_SOLDIERS
			enemy_army.update_number_of_soldiers(0)
			enemy_army.defeat()
			is_in_battle=false
			$number_of_soldiers.text = str(NUMBER_OF_SOLDIERS)
		elif NUMBER_OF_SOLDIERS<enemy_army.NUMBER_OF_SOLDIERS:
			enemy_army.update_number_of_soldiers(enemy_army.NUMBER_OF_SOLDIERS - NUMBER_OF_SOLDIERS)
			NUMBER_OF_SOLDIERS = 0
			$number_of_soldiers.text = str(NUMBER_OF_SOLDIERS)
			defeat()
		elif NUMBER_OF_SOLDIERS == enemy_army.NUMBER_OF_SOLDIERS:
			enemy_army.update_number_of_soldiers(0)
			NUMBER_OF_SOLDIERS = 1
			$number_of_soldiers.text = str(NUMBER_OF_SOLDIERS)
			enemy_army.defeat()
			is_in_battle=false
		enemy_army = null

func _on_battle_timer_timeout() -> void:
	queue_free()

func in_battle():
	is_in_battle = true
	
func update_number_of_soldiers(num):
	NUMBER_OF_SOLDIERS = num
