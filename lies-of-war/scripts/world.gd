extends Node2D

# exports for editor
@export var fog: Sprite2D
@export var fogWidth = 1000
@export var fogHeight = 1000
@export var LightTexture: CompressedTexture2D
@export var lightWidth = 300
@export var lightHeight = 300
@export var Army: CharacterBody2D
@export var debounce_time = 0.01

# debounce counter helper
var time_since_last_fog_update = 0.0
var fogImage: Image
var lightImage: Image
var light_offset: Vector2
var fogTexture: ImageTexture
var light_rect: Rect2

# here we cache things when Node2D is ready
func _ready():
	# get Image from CompressedTexture2D and resize it
	lightImage = LightTexture.get_image()
	lightImage.resize(lightWidth, lightHeight)
	
	# get center
	light_offset = Vector2(lightWidth/2, lightHeight/2)
	
	# create black canvas (fog)
	fogImage = Image.create(fogWidth, fogHeight, false, Image.FORMAT_RGBA8)
	fogImage.fill(Color(0, 0, 0, 0.8))  # Slightly transparent black for better visibility
	
	fogTexture = ImageTexture.create_from_image(fogImage)
	fog.texture = fogTexture
	
	# get Rect2 from our Image to use it with .blend_rect() later
	light_rect = Rect2(Vector2.ZERO, lightImage.get_size())
	
	# update fog once so player isn't under fog until first movement
	update_fog(Army.position)

# update our fog
func update_fog(pos):
	# Create a copy of the fogImage to modify
	var updated_fog_image = fogImage.duplicate()
	
	# Blend the light texture at the given position
	updated_fog_image.blend_rect(lightImage, light_rect, pos - light_offset)
	
	# Update the fog image
	fogImage = updated_fog_image
	fogTexture = ImageTexture.create_from_image(fogImage)
	fog.texture = fogTexture

# main render loop
func _process(delta):
	time_since_last_fog_update += delta
	
	# Check if debounce time has passed
	if time_since_last_fog_update >= debounce_time:
		# Check if player is moving
		if Army.velocity.length() > 0:
			time_since_last_fog_update = 0.0
			update_fog(Army.position)
