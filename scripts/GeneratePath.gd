class_name GeneratePath extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func count_pieces(piece_array : Array):
	DataHandler.white_left = 0
	DataHandler.black_left = 0
	DataHandler.black_queens = 0
	DataHandler.white_queens = 0
	for p in piece_array:
		if p is Piece:
			match p.type:
				DataHandler.PieceNames.WHITE_PAWN:
					DataHandler.white_left += 1
				DataHandler.PieceNames.WHITE_QUEEN:
					DataHandler.white_left += 1
					DataHandler.white_queens += 1
				DataHandler.PieceNames.BLACK_PAWN:
					DataHandler.black_left += 1
				DataHandler.PieceNames.BLACK_QUEEN:
					DataHandler.black_left += 1
					DataHandler.black_queens += 1
	
	if DataHandler.debug == true:
		print("Białe pionki: " + str(DataHandler.white_left))
		print("Białe damki: " + str(DataHandler.white_queens))
		print("Czarne pionki: " + str(DataHandler.black_left))
		print("Czarne damki: " + str(DataHandler.black_queens))

func evaluate():
	return DataHandler.white_left - DataHandler.black_left + (DataHandler.white_queens * 0.5) - (DataHandler.black_queens * 0.5)
	
func GeneratePawnsMoveset(piece : Piece, piece_array : Array) -> Array:
	var type = piece.type
	var slot_id = piece.slot_ID
	var legalMoves := []
	var tempPiece
	
	if type == DataHandler.PieceNames.WHITE_PAWN:
		if (slot_id - 7) % 8 != 0 and (slot_id - 7) > 0:
			if piece_array[slot_id - 7] is Piece:
				tempPiece = piece_array[slot_id - 7]
				var behindSlot = tempPiece.slot_ID - 7
				if behindSlot > 0 and behindSlot % 8 != 0:
					if tempPiece.type > 1 and not (piece_array[behindSlot] is Piece) :
						var newMove = Move.new(slot_id, behindSlot, tempPiece.slot_ID)
						legalMoves.push_back(newMove)
			else:
				var newMove = Move.new(slot_id, slot_id - 7, null)
				legalMoves.push_back(newMove)
		if (slot_id - 9) % 8 != 7 and (slot_id - 9) > 0:
			if piece_array[slot_id - 9] is Piece:
				tempPiece = piece_array[slot_id - 9]
				var behindSlot = tempPiece.slot_ID - 9
				if behindSlot > 0 and behindSlot % 8 != 7:
					if tempPiece.type > 1 and not (piece_array[behindSlot] is Piece) :
						var newMove = Move.new(slot_id, behindSlot, tempPiece.slot_ID)
						legalMoves.push_back(newMove)
			else:
				var newMove = Move.new(slot_id, slot_id - 9, null)
				legalMoves.push_back(newMove)
	elif type == DataHandler.PieceNames.BLACK_PAWN:
		if (slot_id + 7) % 8 != 7 and (slot_id + 7) < 63:
			if piece_array[slot_id + 7] is Piece:
				tempPiece = piece_array[slot_id + 7]
				var behindSlot = tempPiece.slot_ID + 7
				if behindSlot < 63 and behindSlot % 8 != 7:
					if tempPiece.type < 2 and not (piece_array[behindSlot] is Piece):
						var newMove = Move.new(slot_id, behindSlot, tempPiece.slot_ID)
						legalMoves.push_back(newMove)
			else:
				var newMove = Move.new(slot_id, slot_id + 7, null)
				legalMoves.push_back(newMove)
		if (slot_id + 9) % 8 != 0 and (slot_id + 7) < 63:
			if piece_array[slot_id + 9] is Piece:
				tempPiece = piece_array[slot_id + 9]
				var behindSlot = tempPiece.slot_ID + 9
				if behindSlot < 63 and behindSlot % 8 != 0:
					if tempPiece.type < 2 and not (piece_array[behindSlot] is Piece):
						var newMove = Move.new(slot_id, behindSlot, tempPiece.slot_ID)
						legalMoves.push_back(newMove)
			else:
				var newMove = Move.new(slot_id, slot_id + 9, null)
				legalMoves.push_back(newMove)
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
							var newMove = Move.new(slot_id, behindSlot, tempPiece.slot_ID)
							legalMoves.push_back(newMove)
					break;
				else:
					var newMove = Move.new(slot_id, i, null)
					legalMoves.push_back(newMove)
			else:
				break;
		for i in range(slot_id - 7, 0, -7):
			if i % 8 != 0:
				if piece_array[i] is Piece:
					tempPiece = piece_array[i]
					var behindSlot = tempPiece.slot_ID - 7
					if behindSlot > 0 and behindSlot % 8 != 0:
						if tempPiece.type > 1 and not (piece_array[behindSlot] is Piece):
							var newMove = Move.new(slot_id, behindSlot, tempPiece.slot_ID)
							legalMoves.push_back(newMove)
					break;
				else:
					var newMove = Move.new(slot_id, i, null)
					legalMoves.push_back(newMove)
			else:
				break;
		for i in range(slot_id + 9, 64, 9):
			if i % 8 != 0:
				if piece_array[i] is Piece:
					tempPiece = piece_array[i]
					var behindSlot = tempPiece.slot_ID + 9
					if behindSlot < 63 and behindSlot % 8 != 0:
						if tempPiece.type > 1 and not (piece_array[behindSlot] is Piece):
							var newMove = Move.new(slot_id, behindSlot, tempPiece.slot_ID)
							legalMoves.push_back(newMove)
					break;
				else:
					var newMove = Move.new(slot_id, i, null)
					legalMoves.push_back(newMove)
			else:
				break;
		for i in range(slot_id - 9, 0, -9):
			if i % 8 != 7:
				if piece_array[i] is Piece:
					tempPiece = piece_array[i]
					var behindSlot = tempPiece.slot_ID - 9 
					if behindSlot > 0 and behindSlot % 8 != 7:
						if tempPiece.type > 1 and not (piece_array[behindSlot] is Piece):
							var newMove = Move.new(slot_id, behindSlot, tempPiece.slot_ID)
							legalMoves.push_back(newMove)
					break;
				else:
					var newMove = Move.new(slot_id, i, null)
					legalMoves.push_back(newMove)
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
							var newMove = Move.new(slot_id, behindSlot, tempPiece.slot_ID)
							legalMoves.push_back(newMove)
					break;
				else:
					var newMove = Move.new(slot_id, i, null)
					legalMoves.push_back(newMove)
			else:
				break;
		for i in range(slot_id - 7, 0, -7):
			if i % 8 != 0:
				if piece_array[i] is Piece:
					tempPiece = piece_array[i]
					var behindSlot = tempPiece.slot_ID - 7
					if behindSlot > 0 and behindSlot % 8 != 0:
						if tempPiece.type < 2 and not (piece_array[behindSlot] is Piece):
							var newMove = Move.new(slot_id, behindSlot, tempPiece.slot_ID)
							legalMoves.push_back(newMove)
					break;
				else:
					var newMove = Move.new(slot_id, i, null)
					legalMoves.push_back(newMove)
			else:
				break;
		for i in range(slot_id + 9, 64, 9):
			if i % 8 != 0:
				if piece_array[i] is Piece:
					tempPiece = piece_array[i]
					var behindSlot = tempPiece.slot_ID + 9
					if behindSlot < 63 and behindSlot % 8 != 0:
						if tempPiece.type < 2 and not (piece_array[behindSlot] is Piece):
							var newMove = Move.new(slot_id, behindSlot, tempPiece.slot_ID)
							legalMoves.push_back(newMove)
					break;
				else:
					var newMove = Move.new(slot_id, i, null)
					legalMoves.push_back(newMove)
			else:
				break;
		for i in range(slot_id - 9, 0, -9):
			if i % 8 != 7:
				if piece_array[i] is Piece:
					tempPiece = piece_array[i]
					var behindSlot = tempPiece.slot_ID - 9
					if behindSlot > 0 and behindSlot % 8 != 7:
						if tempPiece.type < 2 and not (piece_array[behindSlot] is Piece):
							var newMove = Move.new(slot_id, behindSlot, tempPiece.slot_ID)
							legalMoves.push_back(newMove)
					break;
				else:
					var newMove = Move.new(slot_id, i, null)
					legalMoves.push_back(newMove)
			else:
				break;
	return legalMoves

func get_all_pieces(piece_array : Array, side : DataHandler.Sides):
	var pieces := []
	for p in piece_array:
		if p is Piece:
			if side == DataHandler.Sides.WHITE:
				if p.type < 2:
					pieces.append(p)
			elif side == DataHandler.Sides.BLACK:
				if p.type > 1:
					pieces.append(p)
	return pieces
					
func get_valid_moves(piece : Piece, piece_array : Array):
	match piece.type:
		DataHandler.PieceNames.WHITE_PAWN:
			return GeneratePawnsMoveset(piece, piece_array)
		DataHandler.PieceNames.WHITE_QUEEN:
			return GenerateQueensMoveset(piece, piece_array)
		DataHandler.PieceNames.BLACK_PAWN:
			return GeneratePawnsMoveset(piece, piece_array)
		DataHandler.PieceNames.BLACK_QUEEN:
			return GenerateQueensMoveset(piece, piece_array)
