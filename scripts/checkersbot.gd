extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# MinMax Algorithm is a decision rule used in AI.
# Its for minimizing the possible loss for a worst case scenario
# One side will try to maximize the value, other will try to minimize
# Logic for evaluating the score GeneratePath.evaluate()

func minimax(board : Array, depth, player : DataHandler.Sides):
	var maxEval
	var minEval
	var evaluation
	var best_board
	
	# Checking if depth is 0 so no more minmax, or checking if move is the winner move
	if depth == 0 or DataHandler.check_board_winner(board[0]) == true:
		# Counting pieces and returning array with [piece_array[], move[piece_slot, move_slot, jump_slot], score]
		var pieces_left = GeneratePath.count_pieces(board[0])
		return [board[0], board[1], GeneratePath.evaluate(pieces_left)]
		
	# Maximizing player is AI or Black Pieces
	if player == DataHandler.Sides.BLACK:
		
		# Minimal value for the best results
		maxEval = float(-INF)
		# Getting all moves available for the black pieces
		var board_array = get_all_moves(board[0], DataHandler.Sides.BLACK)
		
		# Looping every move
		for b in board_array:
			# Going deeper, minimizing losses
			evaluation = minimax(b, depth-1, DataHandler.Sides.WHITE)[2]
			
			# Checking better value to take for minimizing the loss
			maxEval = max(maxEval, evaluation)
			if evaluation != null and maxEval == evaluation:
				best_board = b
				
		# Returning best move
		return best_board
	# Maximizing player or White Pieces
	else: 
		
		# Max value for the best results
		minEval = float(INF)
		
		# Getting all moves available for the black pieces
		var board_array = get_all_moves(board[0], DataHandler.Sides.WHITE)
		
		# Looping every move
		for b in board_array:
			# Going deeper, Maximizing gain
			evaluation = minimax(b, depth-1, DataHandler.Sides.BLACK)[2]
			
			# Checking better value to take for minimizing the loss
			minEval = min(minEval, evaluation)
			if minEval == evaluation:
				best_board = b
		
		# Returning best move
		return best_board

# Simulating moves for the AI
func simulate_move(piece, move, piece_array):
	var pieceLocation = move[0]
	var moveLocation = move[1]
	var jumpLocation = move[2]
	var pieceType = piece_array[pieceLocation]
	if jumpLocation != null:
		piece_array[jumpLocation] = -1
	piece_array[pieceLocation] = -1 # Usuwanie pionka z oryginalnej pozycji
	piece_array[moveLocation] = piece # Poruszenie do nowej lokacji
	
	return piece_array
	
# Getting all possible moves for pieces
func get_all_moves(piece_array : Array, side : DataHandler.Sides):
	var boards := []
	var pieces = GeneratePath.get_all_pieces(piece_array, side)
	var counter = 0
	for piece in pieces:
		if piece in DataHandler.PieceNames.values():
			var valid_moves = GeneratePath.get_valid_moves(counter, piece, piece_array)
			for move in valid_moves:
				if move[1] != null:
					var temp_piece_array = GeneratePath.get_all_pieces(piece_array, DataHandler.Sides.ALL)
					var temp_piece = temp_piece_array[counter]
					var new_piece_array = simulate_move(temp_piece, move, temp_piece_array)
					var pieces_left = GeneratePath.count_pieces(new_piece_array)
					var new_board = [new_piece_array, move, GeneratePath.evaluate(pieces_left)]
					boards.append(new_board)
		counter += 1
			
	return boards

