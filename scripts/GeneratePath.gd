extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Logic for counting pieces
# Its used to make delta for the AI
func count_pieces(piece_array : Array):
	var white_left = 0
	var black_left = 0
	var black_queens = 0
	var white_queens = 0
	for p in piece_array:
		if p is Piece:
			match p.type:
				DataHandler.PieceNames.WHITE_PAWN:
					white_left += 1
				DataHandler.PieceNames.WHITE_QUEEN:
					white_left += 1
					white_queens += 1
				DataHandler.PieceNames.BLACK_PAWN:
					black_left += 1
				DataHandler.PieceNames.BLACK_QUEEN:
					black_left += 1
					black_queens += 1
	
	if DataHandler.debug == true:
		print("Białe pionki: " + str(white_left))
		print("Białe damki: " + str(white_queens))
		print("Czarne pionki: " + str(black_left))
		print("Czarne damki: " + str(black_queens))
	return [white_left, white_queens, black_left, black_queens]

# Basic delta for AI
func evaluate(pieces_left : Array):
	return pieces_left[2] - pieces_left[0] + (pieces_left[3] * 0.5) - (pieces_left[1] * 0.5)
	
# Logic for Pawns Moveset
func GeneratePawnsMoveset(slot_id : int, type : DataHandler.PieceNames, piece_array : Array) -> Array:
	var legalMoves := []
	var tempPiece_type
	var tempPiece_slot_id
	
	if type == DataHandler.PieceNames.WHITE_PAWN:
		# Checking for borders
		if (slot_id - 7) % 8 != 0 and (slot_id - 7) > 0:
			# Checking for piece on the corner
			if piece_array[slot_id - 7] in DataHandler.PieceNames.values():
				tempPiece_type = piece_array[slot_id - 7]
				tempPiece_slot_id = slot_id - 7
				var behindSlot = tempPiece_slot_id - 7
				# if piece found check for the next slot to jump
				if behindSlot > 0 and behindSlot % 8 != 0:
					# Enemy and next slot is free so we're adding to legalMoves
					if tempPiece_type > 1 and not (piece_array[behindSlot] in DataHandler.PieceNames.values()) :
						var newMove = [slot_id, behindSlot, tempPiece_slot_id]
						legalMoves.push_back(newMove)
			else:
				# slot is free
				var newMove = [slot_id, slot_id - 7, null]
				legalMoves.push_back(newMove)
		# Checking for borders
		if (slot_id - 9) % 8 != 7 and (slot_id - 9) > 0:
			# Checking for piece on the corner
			if piece_array[slot_id - 9] in DataHandler.PieceNames.values():
				tempPiece_type = piece_array[slot_id - 9]
				tempPiece_slot_id = slot_id - 9
				var behindSlot = tempPiece_slot_id - 9
				# if piece found check for the next slot to jump
				if behindSlot > 0 and behindSlot % 8 != 7:
					# Enemy and next slot is free so we're adding to legalMoves
					if tempPiece_type > 1 and not (piece_array[behindSlot] in DataHandler.PieceNames.values()) :
						var newMove = [slot_id, behindSlot, tempPiece_slot_id]
						legalMoves.push_back(newMove)
			else:
				# slot is free
				var newMove = [slot_id, slot_id - 9, null]
				legalMoves.push_back(newMove)
	elif type == DataHandler.PieceNames.BLACK_PAWN:
		# Checking for borders
		if (slot_id + 7) % 8 != 7 and (slot_id + 7) < 63:
			# Checking for piece on the corner
			if piece_array[slot_id + 7] in DataHandler.PieceNames.values():
				tempPiece_type = piece_array[slot_id + 7]
				tempPiece_slot_id = slot_id + 7
				var behindSlot = tempPiece_slot_id + 7
				# if piece found check for the next slot to jump
				if behindSlot < 63 and behindSlot % 8 != 7:
					# Enemy and next slot is free so we're adding to legalMoves
					if tempPiece_type < 2 and not (piece_array[behindSlot] in DataHandler.PieceNames.values()):
						var newMove = [slot_id, behindSlot, tempPiece_slot_id]
						legalMoves.push_back(newMove)
			else:
				var newMove = [slot_id, slot_id + 7, null]
				legalMoves.push_back(newMove)
		# Checking for borders
		if (slot_id + 9) % 8 != 0 and (slot_id + 7) < 63:
			# Checking for piece on the corner
			if piece_array[slot_id + 9] in DataHandler.PieceNames.values():
				tempPiece_type = piece_array[slot_id + 9]
				tempPiece_slot_id = slot_id + 9
				var behindSlot = tempPiece_slot_id + 9
				# if piece found check for the next slot to jump
				if behindSlot < 63 and behindSlot % 8 != 0:
					# Enemy and next slot is free so we're adding to legalMoves
					if tempPiece_type < 2 and not (piece_array[behindSlot] in DataHandler.PieceNames.values()):
						var newMove = [slot_id, behindSlot, tempPiece_slot_id]
						legalMoves.push_back(newMove)
			else:
				# slot is free
				var newMove = [slot_id, slot_id + 9, null]
				legalMoves.push_back(newMove)
	return legalMoves
	
func GenerateQueensMoveset(slot_id : int, type : DataHandler.PieceNames, piece_array : Array) -> Array:
	var legalMoves := []
	var tempPiece_type
	var tempPiece_slot_id
	
	if type == DataHandler.PieceNames.WHITE_QUEEN:
		# For Queen we're using for loop, rest is the same
		for i in range(slot_id + 7, 64, 7):
			# Checking for borders
			if i % 8 != 7:
				if piece_array[i] in DataHandler.PieceNames.values():
					tempPiece_type = piece_array[i]
					tempPiece_slot_id = i
					var behindSlot = tempPiece_slot_id + 7
					if behindSlot < 63 and behindSlot % 8 != 7:
						if tempPiece_type > 1 and not (piece_array[behindSlot] in DataHandler.PieceNames.values()):
							var newMove = [slot_id, behindSlot, tempPiece_slot_id]
							legalMoves.push_back(newMove)
					break;
				else:
					var newMove = [slot_id, i, null]
					legalMoves.push_back(newMove)
			else:
				break;
		for i in range(slot_id - 7, 0, -7):
			# Checking for borders
			if i % 8 != 0:
				if piece_array[i] in DataHandler.PieceNames.values():
					tempPiece_type = piece_array[i]
					tempPiece_slot_id = i
					var behindSlot = tempPiece_slot_id - 7
					if behindSlot > 0 and behindSlot % 8 != 0:
						if tempPiece_type > 1 and not (piece_array[behindSlot] in DataHandler.PieceNames.values()):
							var newMove = [slot_id, behindSlot, tempPiece_slot_id]
							legalMoves.push_back(newMove)
					break;
				else:
					var newMove = [slot_id, i, null]
					legalMoves.push_back(newMove)
			else:
				break;
		for i in range(slot_id + 9, 64, 9):
			# Checking for borders
			if i % 8 != 0:
				if piece_array[i] in DataHandler.PieceNames.values():
					tempPiece_type = piece_array[i]
					tempPiece_slot_id = i
					var behindSlot = tempPiece_slot_id + 9
					if behindSlot < 63 and behindSlot % 8 != 0:
						if tempPiece_type> 1 and not (piece_array[behindSlot] in DataHandler.PieceNames.values()):
							var newMove = [slot_id, behindSlot, tempPiece_slot_id]
							legalMoves.push_back(newMove)
					break;
				else:
					var newMove = [slot_id, i, null]
					legalMoves.push_back(newMove)
			else:
				break;
		for i in range(slot_id - 9, 0, -9):
			# Checking for borders
			if i % 8 != 7:
				if piece_array[i] in DataHandler.PieceNames.values():
					tempPiece_type = piece_array[i]
					tempPiece_slot_id = i
					var behindSlot = tempPiece_slot_id - 9 
					if behindSlot > 0 and behindSlot % 8 != 7:
						if tempPiece_type > 1 and not (piece_array[behindSlot] in DataHandler.PieceNames.values()):
							var newMove = [slot_id, behindSlot, tempPiece_slot_id]
							legalMoves.push_back(newMove)
					break;
				else:
					var newMove = [slot_id, i, null]
					legalMoves.push_back(newMove)
			else:
				break;
	elif type == DataHandler.PieceNames.BLACK_QUEEN:
		for i in range(slot_id + 7, 64, 7):
			# Checking for borders
			if i % 8 != 7:
				if piece_array[i] in DataHandler.PieceNames.values():
					tempPiece_type = piece_array[i]
					tempPiece_slot_id = i
					var behindSlot = tempPiece_slot_id + 7
					if behindSlot < 63 and behindSlot % 8 != 7:
						if tempPiece_type < 2 and not (piece_array[behindSlot] in DataHandler.PieceNames.values()):
							var newMove = [slot_id, behindSlot, tempPiece_slot_id]
							legalMoves.push_back(newMove)
					break;
				else:
					var newMove = [slot_id, i, null]
					legalMoves.push_back(newMove)
			else:
				break;
		for i in range(slot_id - 7, 0, -7):
			# Checking for borders
			if i % 8 != 0:
				if piece_array[i] in DataHandler.PieceNames.values():
					tempPiece_type = piece_array[i]
					tempPiece_slot_id = i
					var behindSlot = tempPiece_slot_id - 7
					if behindSlot > 0 and behindSlot % 8 != 0:
						if tempPiece_type < 2 and not (piece_array[behindSlot] in DataHandler.PieceNames.values()):
							var newMove = [slot_id, behindSlot, tempPiece_slot_id]
							legalMoves.push_back(newMove)
					break;
				else:
					var newMove = [slot_id, i, null]
					legalMoves.push_back(newMove)
			else:
				break;
		for i in range(slot_id + 9, 64, 9):
			# Checking for borders
			if i % 8 != 0:
				if piece_array[i] in DataHandler.PieceNames.values():
					tempPiece_type = piece_array[i]
					tempPiece_slot_id = i
					var behindSlot = tempPiece_slot_id + 9
					if behindSlot < 63 and behindSlot % 8 != 0:
						if tempPiece_type < 2 and not (piece_array[behindSlot] in DataHandler.PieceNames.values()):
							var newMove = [slot_id, behindSlot, tempPiece_slot_id]
							legalMoves.push_back(newMove)
					break;
				else:
					var newMove = [slot_id, i, null]
					legalMoves.push_back(newMove)
			else:
				break;
		for i in range(slot_id - 9, 0, -9):
			# Checking for borders
			if i % 8 != 7:
				if piece_array[i] in DataHandler.PieceNames.values():
					tempPiece_type = piece_array[i]
					tempPiece_slot_id = i
					var behindSlot = tempPiece_slot_id - 9
					if behindSlot > 0 and behindSlot % 8 != 7:
						if tempPiece_type < 2 and not (piece_array[behindSlot] in DataHandler.PieceNames.values()):
							var newMove = [slot_id, behindSlot, tempPiece_slot_id]
							legalMoves.push_back(newMove)
					break;
				else:
					var newMove = [slot_id, i, null]
					legalMoves.push_back(newMove)
			else:
				break;
	return legalMoves

# Logic for converting main piece_array to array with only types
# Its for not making any memory leaks so the game is smooth and not
# memory consuming
# We can use this function for making array with pieces from only one Side
func get_all_pieces(piece_array : Array, side : DataHandler.Sides):
	var pieces := []
	if side == DataHandler.Sides.ALL:
		for p in piece_array:
			if p in DataHandler.PieceNames.values():
				pieces.append(p)
			if p is Piece:
				pieces.append(p.type)
			else:
				pieces.append(-1)
	else:
		for p in piece_array:
			if p in DataHandler.PieceNames.values():
				if side == DataHandler.Sides.BLACK:
					if p > 1:
						pieces.append(p)
					else:
						pieces.append(-1)
				elif side == DataHandler.Sides.WHITE:
					if p < 2 and p != -1:
						pieces.append(p)
					else:
						pieces.append(-1)
			else:
				pieces.append(-1)
	return pieces

# Helper logic for generating movesets
func get_valid_moves(slot_id, type, piece_array : Array, ):
	match type:
		DataHandler.PieceNames.WHITE_PAWN:
			return GeneratePawnsMoveset(slot_id, type, piece_array)
		DataHandler.PieceNames.WHITE_QUEEN:
			return GenerateQueensMoveset(slot_id, type, piece_array)
		DataHandler.PieceNames.BLACK_PAWN:
			return GeneratePawnsMoveset(slot_id, type, piece_array)
		DataHandler.PieceNames.BLACK_QUEEN:
			return GenerateQueensMoveset(slot_id, type, piece_array)
