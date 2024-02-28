extends Control

var maskImage: Image = Image.new()
var maskTexture: ImageTexture = ImageTexture.new()

@onready var textureRect = $TextureRect

@export var animationPlayer: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer = $AnimationPlayer
	
	maskImage = get_viewport().get_texture().get_image()
	
	maskTexture = ImageTexture.create_from_image(maskImage)
	
	textureRect.texture = maskTexture
