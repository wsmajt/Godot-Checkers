class_name Board extends Node

var piece_array := []
var move : Move
var evaluation : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _init(piece_array_value : Array, move_object : Move, evaluation_value : float):
	piece_array = piece_array_value
	move = move_object
	evaluation = evaluation_value

func check_board_winner() -> bool:
	var pieces = self.piece_array
	var whitePieces := []
	var whitePaths := []
	var blackPieces := []
	var blackPaths := []
	
	for piece in pieces:
		if piece is Piece:
			match piece.type:
				DataHandler.PieceNames.WHITE_PAWN:
					whitePieces.append(piece)
				DataHandler.PieceNames.WHITE_QUEEN:
					whitePieces.append(piece)
				DataHandler.PieceNames.BLACK_PAWN:
					blackPieces.append(piece)
				DataHandler.PieceNames.BLACK_QUEEN:
					blackPieces.append(piece)
					
	if whitePieces.size() == 0 or blackPieces.size() == 0:
		return true
	else:
		for p in whitePieces:
			if p.type == DataHandler.PieceNames.WHITE_PAWN:
				whitePaths.append_array(GeneratePath.GeneratePawnsMoveset(p, pieces)) 
			else:
				whitePaths.append_array(GeneratePath.GenerateQueensMoveset(p, pieces)) 
				
		if whitePaths.size() == 0:
			return true
			
		for p in blackPieces:
			if p.type == DataHandler.PieceNames.BLACK_PAWN:
				blackPaths.append_array(GeneratePath.GeneratePawnsMoveset(p, pieces)) 
			else:
				blackPaths.append_array(GeneratePath.GenerateQueensMoveset(p, pieces)) 
		
		if blackPaths.size() == 0:
			return true
	return false
