extends Node

# Data Handler
# Util Enums and Functions

# DEBUG
var debug = false

var assets := []
enum PieceNames {WHITE_PAWN, WHITE_QUEEN, BLACK_PAWN, BLACK_QUEEN}
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
func check_board_winner(piece_array : Array) -> bool:
	var pieces = piece_array
	var whitePieces := []
	var whitePaths := []
	var blackPieces := []
	var blackPaths := []
	
	# Sorting pieces
	for piece in pieces:
		if piece in DataHandler.PieceNames.values():
			match piece:
				DataHandler.PieceNames.WHITE_PAWN:
					whitePieces.append(piece)
				DataHandler.PieceNames.WHITE_QUEEN:
					whitePieces.append(piece)
				DataHandler.PieceNames.BLACK_PAWN:
					blackPieces.append(piece)
				DataHandler.PieceNames.BLACK_QUEEN:
					blackPieces.append(piece)
		else :
			whitePieces.append(-1)
			blackPieces.append(-1)
					
	# If no pieces left -> Winner
	if whitePieces.size() == 0 or blackPieces.size() == 0:
		return true
	else:
		var counter = 0
		# Checking paths that pieces can move
		for p in whitePieces:
			if p == DataHandler.PieceNames.WHITE_PAWN:
				whitePaths.append_array(GeneratePath.GeneratePawnsMoveset(counter, p, pieces)) 
			elif p == DataHandler.PieceNames.WHITE_QUEEN:
				whitePaths.append_array(GeneratePath.GenerateQueensMoveset(counter, p, pieces)) 
			counter += 1
				
		if whitePaths.size() == 0:
			# No Paths -> Winner
			return true
		
		counter = 0
		# Checking paths that pieces can move
		for p in blackPieces:
			if p == DataHandler.PieceNames.BLACK_PAWN:
				blackPaths.append_array(GeneratePath.GeneratePawnsMoveset(counter, p, pieces)) 
			elif p == DataHandler.PieceNames.BLACK_QUEEN:
				blackPaths.append_array(GeneratePath.GenerateQueensMoveset(counter, p, pieces)) 
			counter += 1
		if blackPaths.size() == 0:
			# No Paths -> Winner
			return true
			
	return false

# Called when the node enters the scene tree for the first time.
func _ready():
	assets.append("res://graphics/whitefig.png")
	assets.append("res://graphics/whitefig_queen.png")
	assets.append("res://graphics/blackfig.png")
	assets.append("res://graphics/blackfig_queen.png")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
