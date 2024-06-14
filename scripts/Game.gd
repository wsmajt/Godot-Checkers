extends Control

# Scenes
@onready var slot_scene = preload("res://scenes/slot.tscn")
@onready var piece_scene = preload("res://prefabs/piece.tscn")

# References
@onready var board_grid = $Board/BoardGrid
@onready var board = $Board
@onready var StatusLabel = $StatusLabel

# Sounds
@onready var AudioPlayer = $AudioStreamPlayer2D
@onready var startGameSound = preload("res://sounds/startgame.ogg")
@onready var pieceMoveSound = preload("res://sounds/piecemove.ogg")

var debug = false

var grid_array := []
var piece_array := []
var icon_offset := Vector2(40.5, 40.5)
#"1p1p1p1p/p1p1p1p1/1p1p1p1p/8/8/P1P1P1P1/1P1P1P1P/P1P1P1P1 w - 0 1"
#"1p1p1p1p/p1p1p1p1/1p1p1p1p/8/8/4Q3/8/8 w - 0 1" damka testy
var fen = "1p1p1p1p/p1p1p1p1/1p1p1p1p/8/8/P1P1P1P1/1P1P1P1P/P1P1P1P1 w - 0 1"
var whosMove := DataHandler.Sides.WHITE 
var gamestart :=false

var piece_selected = null
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(64):
		create_slot()
		
	var colorbit = 0
	for i in range(8):
		for j in range(8):
			if j%2 == colorbit:
				grid_array[i*8+j].set_background(Color(185,185,185))
		if colorbit == 0:
			colorbit = 1
		else: colorbit = 0
		
	piece_array.resize(64)
	piece_array.fill(0)
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("mouse_right") and piece_selected:
		piece_selected = null
		clear_board_filter()

func create_slot():
	var new_slot = slot_scene.instantiate()
	new_slot.slot_ID = grid_array.size()
	board_grid.add_child(new_slot)
	grid_array.push_back(new_slot)
	if debug:
		new_slot._dev_changetext(str(new_slot.slot_ID))
	new_slot.slot_clicked.connect(_on_slot_clicked)

func _on_slot_clicked(slot) -> void:
	if not piece_selected:
		return
	if slot.state != DataHandler.slot_states.FREE: return
	move_piece(piece_selected, slot.slot_ID)
	clear_board_filter()
	piece_selected = null
	
	if gamestart == true:
		whosMove = DataHandler.getNextSide(whosMove)
		if whosMove == DataHandler.Sides.WHITE:
			StatusLabel.text = "Ruch gracza białego!"
		else:
			StatusLabel.text = "Ruch gracza czarnego!"

func update_board(from_loc, to_loc) -> void:
	if piece_array[to_loc]:
		if piece_array[to_loc].type%2 == 1: 
			gamestart = false
		piece_array[to_loc].queue_free()
		piece_array[to_loc] = 0
	var tween = get_tree().create_tween()	
	tween.tween_property(piece_array[from_loc], "global_position",grid_array[to_loc].global_position + icon_offset, 0.1)
	piece_array[to_loc] = piece_array[from_loc] # move it to the new location
	piece_array[from_loc] = 0 # delete piece from original spot
	piece_array[to_loc].slot_ID = to_loc # change the piece location
	
	
func move_piece(piece, location)-> void:
	var pieceLocation = piece.slot_ID
	var hitMovesList = GeneratePath.GetHitMovesList()
	
	if hitMovesList.has(location):
		piece_array[hitMovesList[location]].queue_free()
		piece_array[hitMovesList[location]] = 0
		
		var foundEnemyPieces = false
		var foundPieces := []
		var foundPaths := []
		for p in piece_array:
			if piece.type in [DataHandler.PieceNames.WHITE_PAWN, DataHandler.PieceNames.WHITE_QUEEN] and p is Piece:
				if p.type > 1:
					foundEnemyPieces = true
					foundPieces.append(p)
			elif piece.type in [DataHandler.PieceNames.BLACK_PAWN, DataHandler.PieceNames.BLACK_QUEEN] and p is Piece:
				if p.type < 2:
					foundEnemyPieces = true
					foundPieces.append(p)
		
		if foundEnemyPieces == true:
			for p in foundPieces:
				if p.type in [DataHandler.PieceNames.WHITE_PAWN, DataHandler.PieceNames.BLACK_PAWN]:
					foundPaths.append_array(GeneratePath.GeneratePawnsMoveset(p, piece_array)) 
				else:
					foundPaths.append_array(GeneratePath.GenerateQueensMoveset(p, piece_array)) 
			
			if foundPaths.size() == 0:
				end_Game(piece)
			
		
		if foundEnemyPieces == false:
			end_Game(piece)
		
		GeneratePath.ClearHitMovesList()
		
	AudioPlayer.stream = pieceMoveSound
	AudioPlayer.play()
	var tween = get_tree().create_tween()
	tween.tween_property(piece, "global_position", grid_array[location].global_position + icon_offset, 0.2)
	piece_array[piece.slot_ID] = null # Usuwanie pionka z oryginalnej pozycji
	piece_array[location] = piece # Poruszenie do nowej lokacji
	piece.slot_ID = location
	
	if location >= 56 and location <= 63 and piece.type == DataHandler.PieceNames.BLACK_PAWN:
		piece.type = DataHandler.PieceNames.BLACK_QUEEN
		piece.load_icon(piece.type)
	elif location >= 0 and location <= 7 and piece.type == DataHandler.PieceNames.WHITE_PAWN:
		piece.type = DataHandler.PieceNames.WHITE_QUEEN
		piece.load_icon(piece.type)
	
func add_piece(piece_type, location) -> void:
	var new_piece = piece_scene.instantiate()
	board.add_child(new_piece)
	new_piece.type = piece_type
	new_piece.load_icon(piece_type)
	new_piece.global_position = grid_array[location].global_position + icon_offset
	piece_array[location] = new_piece
	new_piece.slot_ID = location
	new_piece.piece_selected.connect(_on_piece_selected)
	
func _on_piece_selected(piece):
	if piece_selected:
		_on_slot_clicked(grid_array[piece.slot_ID])
	elif gamestart == true:
		match whosMove:
			DataHandler.Sides.WHITE:
				if piece.type == DataHandler.PieceNames.WHITE_PAWN or piece.type == DataHandler.PieceNames.WHITE_QUEEN:
					piece_selected = piece
					match piece.type:
						DataHandler.PieceNames.WHITE_PAWN:
							var legalMoves = GeneratePath.GeneratePawnsMoveset(piece, piece_array)
							set_board_filter(legalMoves)
						DataHandler.PieceNames.WHITE_QUEEN:
							var legalMoves = GeneratePath.GenerateQueensMoveset(piece, piece_array)
							set_board_filter(legalMoves)
			DataHandler.Sides.BLACK:
				if piece.type == DataHandler.PieceNames.BLACK_PAWN or piece.type == DataHandler.PieceNames.BLACK_QUEEN:
					piece_selected = piece
					match piece.type:
						DataHandler.PieceNames.BLACK_PAWN:
							var legalMoves = GeneratePath.GeneratePawnsMoveset(piece, piece_array)
							set_board_filter(legalMoves)
						DataHandler.PieceNames.BLACK_QUEEN:
							var legalMoves = GeneratePath.GenerateQueensMoveset(piece, piece_array)
							set_board_filter(legalMoves)
	
func set_board_filter(slotsArray : Array):
	for i in slotsArray:
		grid_array[i].set_filter(DataHandler.slot_states.FREE)

func clear_board_filter():
	for i in grid_array:
		i.set_filter()
		
func parse_fen(fen : String) -> void:
	var boardstate = fen.split(" ")
	var board_index := 0
	for i in boardstate[0]:
		if i == "/":continue
		if i.is_valid_int():
			board_index += i.to_int()
		else:
			add_piece(DataHandler.fen_dict[i], board_index)
			board_index += 1

func clear_piece_array()->void:
	for i in piece_array:
		if i:
			i.queue_free()
	piece_array.fill(0)
	

func end_Game(piece : Piece):
	gamestart = false
	if piece.type in [DataHandler.PieceNames.WHITE_PAWN, DataHandler.PieceNames.WHITE_QUEEN]:
		StatusLabel.text = "Wygrał gracz biały!"
	elif piece.type in [DataHandler.PieceNames.BLACK_PAWN, DataHandler.PieceNames.BLACK_QUEEN]:
		StatusLabel.text = "Wygrał gracz czarny!"

func _play_button_pressed():
	clear_piece_array()
	clear_board_filter()
	whosMove = DataHandler.Sides.WHITE
	StatusLabel.text = "Zaczyna gracz biały!"
	AudioPlayer.stream = startGameSound
	AudioPlayer.play()
	piece_selected = null
	parse_fen(fen)
	gamestart = true;
