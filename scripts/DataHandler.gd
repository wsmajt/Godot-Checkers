extends Node

# DEBUG
var debug = false

# MinMax Algorithm
var white_left = 0
var white_queens = 0
var black_left = 0
var black_queens = 0

var assets := []
enum PieceNames {WHITE_PAWN, WHITE_QUEEN, BLACK_PAWN, BLACK_QUEEN}
var fen_dict := {
	"P" = PieceNames.WHITE_PAWN,
	"Q" = PieceNames.WHITE_QUEEN,
	"p" = PieceNames.BLACK_PAWN,
	"q" = PieceNames.BLACK_QUEEN
}
enum Sides {WHITE, BLACK}
enum slot_states {NONE, FREE}

func getNextSide(side : Sides):
	if side == Sides.WHITE:
		return Sides.BLACK
	else:
		return Sides.WHITE

# Called when the node enters the scene tree for the first time.
func _ready():
	assets.append("res://graphics/whitefig.png")
	assets.append("res://graphics/whitefig_queen.png")
	assets.append("res://graphics/blackfig.png")
	assets.append("res://graphics/blackfig_queen.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
