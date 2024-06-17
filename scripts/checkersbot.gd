extends Node

@onready var piece_scene = preload("res://prefabs/piece.tscn")

# MinMax Algorithm
var winner = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var licznik = 0
func minimax(board : Board, depth, player : DataHandler.Sides):
	var maxEval
	var minEval
	var evaluation
	var best_board
	
	if depth == 0 or board.check_board_winner() == true:
		var pieces_left = GeneratePath.count_pieces(board.piece_array)
		return Board.new(board.piece_array, board.move, GeneratePath.evaluate(pieces_left))
		
	# Gracz maksymalizujacy wynik
	if player == DataHandler.Sides.BLACK:
		maxEval = float(-INF)
		var board_array = get_all_moves(board.piece_array, DataHandler.Sides.BLACK)
		for b in board_array:
			evaluation = minimax(b, depth-1, DataHandler.Sides.WHITE).evaluation
			maxEval = max(maxEval, evaluation)
			if evaluation != null and maxEval == evaluation:
				best_board = b
		return best_board
	else: # Gracz minimalizujacy wynik
		minEval = float(INF)
		var board_array = get_all_moves(board.piece_array, DataHandler.Sides.WHITE)
		for b in board_array:
			evaluation = minimax(b, depth-1, DataHandler.Sides.BLACK).evaluation
			minEval = min(minEval, evaluation)
			if minEval == evaluation:
				best_board = b
		return best_board

func simulate_move(piece, move, piece_array):
	var pieceLocation = move.piece_id
	var moveLocation = move.move_id
	var jumpLocation = move.jump_id
	var pieceType = piece_array[pieceLocation].type
	if jumpLocation != null:
		piece_array[jumpLocation].queue_free()
		piece_array[jumpLocation] = 0
	piece_array[pieceLocation] = 0 # Usuwanie pionka z oryginalnej pozycji
	piece_array[moveLocation] = piece # Poruszenie do nowej lokacji
	piece.slot_ID = moveLocation
	
	return piece_array
	
func get_all_moves(piece_array : Array, side : DataHandler.Sides):
	var moves := []
	
	var pieces = GeneratePath.get_all_pieces(piece_array, side)
	for piece in pieces:
		var valid_moves = GeneratePath.get_valid_moves(piece, piece_array)
		for move in valid_moves:
			if move.move_id != null:
				var temp_piece_array = deepcopy_array(piece_array)
				var temp_piece = find_piece_in_array(temp_piece_array, piece.slot_ID)
				var new_piece_array = simulate_move(temp_piece, move, temp_piece_array)
				var pieces_left = GeneratePath.count_pieces(new_piece_array)
				var new_board = Board.new(new_piece_array, move, GeneratePath.evaluate(pieces_left))
				moves.append(new_board)
			
	return moves

func find_piece_in_array(piece_array : Array, slot_id : int):
	for piece in piece_array:
		if piece is Piece and piece.slot_ID == slot_id:
			return piece
			

func deepcopy_array(array):
	var new_array = []
	for item in array:
		if item is Piece:
			var new_piece = piece_scene.instantiate()
			new_piece.slot_ID = item.slot_ID
			new_piece.type = item.type
			new_piece.icon_path = item.icon_path
			new_array.append(new_piece)
		else:
			new_array.append(item)
	return new_array
