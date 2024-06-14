extends Node

var hitMovesList := {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func GetHitMovesList():
	return hitMovesList

func ClearHitMovesList():
	hitMovesList.clear()

func GeneratePawnsMoveset(piece : Piece, piece_array : Array) -> Array:
	var type = piece.type
	var slot_id = piece.slot_ID
	var legalMoves := []
	var tempPiece
	
	if type == DataHandler.PieceNames.WHITE_PAWN:
		if (slot_id - 7) % 8 != 0:
			if piece_array[slot_id - 7] is Piece:
				tempPiece = piece_array[slot_id - 7]
				var behindSlot = tempPiece.slot_ID - 7
				if behindSlot > 0 and behindSlot % 8 != 0:
					if tempPiece.type > 1 and not (piece_array[behindSlot] is Piece) :
						hitMovesList[behindSlot] = tempPiece.slot_ID  
						legalMoves.push_back(behindSlot)
			else:
				legalMoves.push_back(slot_id - 7)
		if (slot_id - 9) % 8 != 7:
			if piece_array[slot_id - 9] is Piece:
				tempPiece = piece_array[slot_id - 9]
				var behindSlot = tempPiece.slot_ID - 9
				if behindSlot > 0 and behindSlot % 8 != 7:
					if tempPiece.type > 1 and not (piece_array[behindSlot] is Piece) :
						hitMovesList[behindSlot] = tempPiece.slot_ID  
						legalMoves.push_back(behindSlot)
			else:
				legalMoves.push_back(slot_id - 9)
	elif type == DataHandler.PieceNames.BLACK_PAWN:
		if (slot_id + 7) % 8 != 7:
			if piece_array[slot_id + 7] is Piece:
				tempPiece = piece_array[slot_id + 7]
				var behindSlot = tempPiece.slot_ID + 7
				if behindSlot < 63 and behindSlot % 8 != 7:
					if tempPiece.type < 2 and not (piece_array[behindSlot] is Piece):
						hitMovesList[behindSlot] = tempPiece.slot_ID  
						legalMoves.push_back(behindSlot)
			else:
				legalMoves.push_back(slot_id + 7)
		if (slot_id + 9) % 8 != 0:
			if piece_array[slot_id + 9] is Piece:
				tempPiece = piece_array[slot_id + 9]
				var behindSlot = tempPiece.slot_ID + 9
				if behindSlot < 63 and behindSlot % 8 != 0:
					if tempPiece.type < 2 and not (piece_array[behindSlot] is Piece):
						hitMovesList[behindSlot] = tempPiece.slot_ID 
						legalMoves.push_back(behindSlot)
			else:
				legalMoves.push_back(slot_id + 9)
	return legalMoves
	
func GenerateQueensMoveset(piece : Piece, piece_array : Array) -> Array:
	var type = piece.type
	var slot_id = piece.slot_ID
	var legalMoves := []
	var tempPiece
	
	if type == DataHandler.PieceNames.WHITE_QUEEN:
		for i in range(slot_id + 7, 64, 7):
			if i % 8 != 7:
				if piece_array[i] is Piece:
					tempPiece = piece_array[i]
					var behindSlot = tempPiece.slot_ID + 7
					if behindSlot < 63 and behindSlot % 8 != 7:
						if tempPiece.type > 1 and not (piece_array[behindSlot] is Piece):
							hitMovesList[behindSlot] = tempPiece.slot_ID 
							legalMoves.push_back(behindSlot)
					break;
				else:
					legalMoves.push_back(i)
			else:
				break;
		for i in range(slot_id - 7, 0, -7):
			if i % 8 != 0:
				if piece_array[i] is Piece:
					tempPiece = piece_array[i]
					var behindSlot = tempPiece.slot_ID - 7
					if behindSlot > 0 and behindSlot % 8 != 0:
						if tempPiece.type > 1 and not (piece_array[behindSlot] is Piece):
							hitMovesList[behindSlot] = tempPiece.slot_ID
							legalMoves.push_back(behindSlot)
					break;
				else:
					legalMoves.push_back(i)
			else:
				break;
		for i in range(slot_id + 9, 64, 9):
			if i % 8 != 0:
				if piece_array[i] is Piece:
					tempPiece = piece_array[i]
					var behindSlot = tempPiece.slot_ID + 9
					if behindSlot < 63 and behindSlot % 8 != 0:
						if tempPiece.type > 1 and not (piece_array[behindSlot] is Piece):
							hitMovesList[behindSlot] = tempPiece.slot_ID
							legalMoves.push_back(behindSlot)
					break;
				else:
					legalMoves.push_back(i)
			else:
				break;
		for i in range(slot_id - 9, 0, -9):
			if i % 8 != 7:
				if piece_array[i] is Piece:
					tempPiece = piece_array[i]
					var behindSlot = tempPiece.slot_ID - 9 
					if behindSlot > 0 and behindSlot % 8 != 7:
						if tempPiece.type > 1 and not (piece_array[behindSlot] is Piece):
							hitMovesList[behindSlot] = tempPiece.slot_ID
							legalMoves.push_back(behindSlot)
					break;
				else:
					legalMoves.push_back(i)
			else:
				break;
	elif type == DataHandler.PieceNames.BLACK_QUEEN:
		for i in range(slot_id + 7, 64, 7):
			if i % 8 != 7:
				if piece_array[i] is Piece:
					tempPiece = piece_array[i]
					var behindSlot = tempPiece.slot_ID + 7
					if behindSlot < 63 and behindSlot % 8 != 7:
						if tempPiece.type < 2 and not (piece_array[behindSlot] is Piece):
							hitMovesList[behindSlot] = tempPiece.slot_ID
							legalMoves.push_back(behindSlot)
					break;
				else:
					legalMoves.push_back(i)
			else:
				break;
		for i in range(slot_id - 7, 0, -7):
			if i % 8 != 0:
				if piece_array[i] is Piece:
					tempPiece = piece_array[i]
					var behindSlot = tempPiece.slot_ID - 7
					if behindSlot > 0 and behindSlot % 8 != 0:
						if tempPiece.type < 2 and not (piece_array[behindSlot] is Piece):
							hitMovesList[behindSlot] = tempPiece.slot_ID
							legalMoves.push_back(behindSlot)
					break;
				else:
					legalMoves.push_back(i)
			else:
				break;
		for i in range(slot_id + 9, 64, 9):
			if i % 8 != 0:
				if piece_array[i] is Piece:
					tempPiece = piece_array[i]
					var behindSlot = tempPiece.slot_ID + 9
					if behindSlot < 63 and behindSlot % 8 != 0:
						if tempPiece.type < 2 and not (piece_array[behindSlot] is Piece):
							hitMovesList[behindSlot] = tempPiece.slot_ID
							legalMoves.push_back(behindSlot)
					break;
				else:
					legalMoves.push_back(i)
			else:
				break;
		for i in range(slot_id - 9, 0, -9):
			if i % 8 != 7:
				if piece_array[i] is Piece:
					tempPiece = piece_array[i]
					var behindSlot = tempPiece.slot_ID - 9
					if behindSlot > 0 and behindSlot % 8 != 7:
						if tempPiece.type < 2 and not (piece_array[behindSlot] is Piece):
							hitMovesList[behindSlot] = tempPiece.slot_ID
							legalMoves.push_back(behindSlot)
					break;
				else:
					legalMoves.push_back(i)
			else:
				break;
	return legalMoves
