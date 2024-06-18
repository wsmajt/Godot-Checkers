class_name Piece extends Node2D

# Piece prefab script
# Util Functions

# References to the objects from the scene
@onready var icon_path = $Icon

# Locals
signal piece_selected(piece)
var slot_ID := -1
var type : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_icon(piece_name) -> void:
	icon_path.texture = load(DataHandler.assets[piece_name])

func _on_icon_gui_input(event):
	if event.is_action_pressed("mouse_left"):
		emit_signal("piece_selected", self)
