extends Node

var assets := []
enum PieceNames {WHITE_PAWN, WHITE_QUEEN, BLACK_PAWN, BLACK_QUEEN}
var fen_dict := {
	"P" = PieceNames.WHITE_PAWN,
	"Q" = PieceNames.WHITE_QUEEN,
	"p" = PieceNames.BLACK_PAWN,
	"q" = PieceNames.BLACK_QUEEN
}
enum slot_states {NONE, FREE}

# Called when the node enters the scene tree for the first time.
func _ready():
	assets.append("res://graphics/whitefig.png")
	assets.append("res://graphics/whitefig_queen.png")
	assets.append("res://graphics/blackfig.png")
	assets.append("res://graphics/blackfig_queen.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
