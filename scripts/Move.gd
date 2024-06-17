class_name Move extends Node

var piece_id : int
var move_id : int
var jump_id

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _init(piece_id_value : int, move_id_value : int, jump_id_value) -> void:
	piece_id = piece_id_value
	move_id = move_id_value
	jump_id = jump_id_value
