extends Node

@onready var AIGeneratePath = GeneratePath.new()

# MinMax Algorithm
var winner = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func minimax(piece_array, depth, player : DataHandler.Sides):
	var maxEval = null
	var minEval = null
	var best_move = null
	var evaluation = null
	if depth == 0 or winner == true:
		return AIGeneratePath.evaluate()
		
	# Gracz minimalizujacy wynik
	if player == DataHandler.Sides.BLACK:
		maxEval = float(-INF)
		for temp_piece_array in get_all_moves(piece_array, DataHandler.Sides.BLACK):
			evaluation = minimax(temp_piece_array[1], depth-1, DataHandler.Sides.WHITE)
			maxEval = max(maxEval, evaluation)
			if maxEval == evaluation:
				best_move = temp_piece_array
		return [maxEval, best_move]
	else: # Gracz maksymalizujacy wynik
		minEval = float(INF)
		for temp_piece_array in get_all_moves(piece_array, DataHandler.Sides.WHITE):
			evaluation = minimax(temp_piece_array[1], depth-1, DataHandler.Sides.BLACK)
			minEval = min(minEval, evaluation)
			if minEval == evaluation:
				best_move = temp_piece_array

func simulate_move(piece, move, piece_array):
	var pieceLocation = piece.slot_ID
	var location = move.move_id
	if move.jump_id != null and move.move_id == location:
		piece_array[move.jump_id].queue_free()
		piece_array[move.jump_id] = 0
	#var winner = check_winner(piece, piece_array)
	#if winner == true:
		#do zrobienia
	piece_array[piece.slot_ID] = null # Usuwanie pionka z oryginalnej pozycji
	piece_array[location] = piece # Poruszenie do nowej lokacji
	piece.slot_ID = location
	
	if location >= 56 and location <= 63 and piece.type == DataHandler.PieceNames.BLACK_PAWN:
		piece.type = DataHandler.PieceNames.BLACK_QUEEN
		piece.load_icon(piece.type)
	elif location >= 0 and location <= 7 and piece.type == DataHandler.PieceNames.WHITE_PAWN:
		piece.type = DataHandler.PieceNames.WHITE_QUEEN
		piece.load_icon(piece.type)
	
	return piece_array
	
func get_all_moves(piece_array : Array, side : DataHandler.Sides):
	var moves := []
	
	var pieces = AIGeneratePath.get_all_pieces(piece_array, side)
	for piece in pieces:
		var valid_moves = AIGeneratePath.get_valid_moves(piece, piece_array)
		for move in valid_moves:
			var temp_piece_array = piece_array.duplicate(true)
			var temp_piece = find_piece_in_array(temp_piece_array, piece.slot_ID)
			var new_piece_array = simulate_move(piece, move, temp_piece_array)
			moves.append([move,new_piece_array])
			
	return moves

func find_piece_in_array(piece_array : Array, slot_id : int):
	for piece in piece_array:
		if piece is Piece and piece.slot_ID == slot_id:
			return piece
