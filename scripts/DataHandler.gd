extends Node

# Data Handler
# Util Enums and Functions

# DEBUG
var debug = false

var assets := []
var repeatedMoves := [[],[]]
enum PieceNames {WHITE_PAWN, WHITE_QUEEN, BLACK_PAWN, BLACK_QUEEN}
enum WinnerSide {WHITE, BLACK, DRAW}
var fen_dict := {
	"P" = PieceNames.WHITE_PAWN,
	"Q" = PieceNames.WHITE_QUEEN,
	"p" = PieceNames.BLACK_PAWN,
	"q" = PieceNames.BLACK_QUEEN
}
enum Sides {WHITE, BLACK, ALL}
enum slot_states {NONE, FREE}

func getNextSide(side : Sides):
	if side == Sides.WHITE:
		return Sides.BLACK
	else:
		return Sides.WHITE
	
# Logic for checking the winner
func check_board_winner(piece_array : Array, whosMove : DataHandler.Sides):
	var pieces := piece_array.duplicate(true)
	
	var whitePieces := []
	var whitePiecesCount = 0
	whitePieces.resize(64)
	whitePieces.fill(-1)
	
	var whitePaths := []
	
	var blackPieces := []
	var blackPiecesCount = 0
	blackPieces.resize(64)
	blackPieces.fill(-1)
	
	var blackPaths := []
	
	var counter = 0
	
	# Sorting pieces
	for piece in pieces:
		if piece in DataHandler.PieceNames.values():
			match piece:
				DataHandler.PieceNames.WHITE_PAWN:
					whitePieces[counter] = piece
					whitePiecesCount += 1
				DataHandler.PieceNames.WHITE_QUEEN:
					whitePieces[counter] = piece
					whitePiecesCount += 1
				DataHandler.PieceNames.BLACK_PAWN:
					blackPieces[counter] = piece
					blackPiecesCount += 1
				DataHandler.PieceNames.BLACK_QUEEN:
					blackPieces[counter] = piece
					blackPiecesCount += 1
		counter += 1
					
	# If no pieces left -> Winner
	if blackPiecesCount == 0:
		return WinnerSide.BLACK
	elif whitePiecesCount == 0:
		return WinnerSide.WHITE
	else:
		counter = 0
		# Checking paths that pieces can move
		for p in whitePieces:
			if p in DataHandler.PieceNames.values():
				whitePaths.append_array(GeneratePath.get_valid_moves(counter, p, pieces)) 
			counter += 1
				
		
		counter = 0
		# Checking paths that pieces can move
		for p in blackPieces:
			if p in DataHandler.PieceNames.values():
				blackPaths.append_array(GeneratePath.get_valid_moves(counter, p, pieces)) 
			counter += 1
			
		if blackPaths.size() == 0 and whosMove == DataHandler.Sides.BLACK:
			return DataHandler.WinnerSide.WHITE
		elif whitePaths.size() == 0 and whosMove == DataHandler.Sides.WHITE:
			return DataHandler.WinnerSide.BLACK
		elif blackPaths.size() == 0 and whitePaths.size() == 0:
			# No Paths -> Draw
			return DataHandler.WinnerSide.DRAW
			
	return null

# Called when the node enters the scene tree for the first time.
func _ready():
	assets.append("res://graphics/whitefig.png")
	assets.append("res://graphics/whitefig_queen.png")
	assets.append("res://graphics/blackfig.png")
	assets.append("res://graphics/blackfig_queen.png")
