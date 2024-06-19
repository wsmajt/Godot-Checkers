class_name Game extends Control

# Theme Styles
@onready var mysterious_style = preload("res://styles/mysterious.tres")

# Scenes
@onready var slot_scene = preload("res://scenes/slot.tscn")
@onready var piece_scene = preload("res://prefabs/piece.tscn")

# References
@onready var board_grid = $Board/BoardGrid
@onready var board = $Board
@onready var background = $Background
@onready var StatusLabel = $Background/StatusLabel
@onready var difficultyDropDown = $Background/DifficultyDropDown
@onready var resetButton = $Background/ResetButton
@onready var playButton = $Background/PlayWithFriend
@onready var playWithAiButton = $Background/PlayWithAI

# Sounds
@onready var AudioPlayer = $AudioStreamPlayer2D
@onready var startGameSound = preload("res://sounds/startgame.ogg")
@onready var pieceMoveSound = preload("res://sounds/piecemove.ogg")
@onready var endGameSound = preload("res://sounds/endgame.ogg")
@onready var mysteriousSound = preload("res://sounds/devil_sound.ogg")

# Locals
var grid_array := []
var piece_array := []
var icon_offset := Vector2(40.5, 40.5)
var legalMoves := []
var fen = "1p1p1p1p/p1p1p1p1/1p1p1p1p/8/8/P1P1P1P1/1P1P1P1P/P1P1P1P1 w - 0 1"
var whosMove = DataHandler.Sides.WHITE 
var gamestart := false
var aiGame := false
var piece_selected = null
var difficulty = 1
var hidden_difficulty_added = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Creating slots where Pieces can move
	for i in range(64):
		create_slot()
		
	var colorbit = 0
	for i in range(8):
		for j in range(8):
			# Setting background color
			if j%2 == colorbit:
				grid_array[i*8+j].set_background(Color(185,185,185))
		if colorbit == 0:
			colorbit = 1
		else: colorbit = 0
		
	# Resizing piece array to 64 slots
	# In checkers we use only half of this slots
	# Filling with -1 (This means that there is no Piece)
	piece_array.resize(64)
	piece_array.fill(-1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Input checked every frame
	if Input.is_action_just_pressed("mouse_right") and piece_selected:
		piece_selected = null
		clear_board_filter()
	elif Input.is_action_just_pressed("hidden_difficulty") and hidden_difficulty_added == false:
		hidden_difficulty_added = true
		AudioPlayer.stream = mysteriousSound
		AudioPlayer.play()
		background.theme = mysterious_style
		difficultyDropDown.add_separator("MEMORY HEAVY")
		difficultyDropDown.add_item("KOSZMAR", 4)

func create_slot():
	# Using slot_scene as prefab
	var new_slot = slot_scene.instantiate()
	new_slot.slot_ID = grid_array.size()
	
	# Adding slot as child to BoardGrid
	board_grid.add_child(new_slot)
	grid_array.push_back(new_slot)
	
	# Debug things
	if DataHandler.debug:
		new_slot._dev_changetext(str(new_slot.slot_ID))
	
	# Connect event to slot
	new_slot.slot_clicked.connect(_on_slot_clicked)

# Event that fires when u click the slot
func _on_slot_clicked(slot) -> void:
	if not piece_selected:
		return
	if slot.state != DataHandler.slot_states.FREE: return
	
	# When piece is selected and Slot is without piece
	# Move there and clear the board filter
	move_piece(piece_selected, slot.slot_ID)
	clear_board_filter()
	piece_selected = null
	
	# Checking if game is still running if yes then change Sides
	if gamestart == true:
		whosMove = DataHandler.getNextSide(whosMove)
		if whosMove == DataHandler.Sides.WHITE:
			StatusLabel.text = "Ruch gracza białego!"
		else:
			StatusLabel.text = "Ruch gracza czarnego!"
	
	# AI Logic for making a move
	if whosMove == DataHandler.Sides.BLACK and aiGame == true:
		# Need to wait 0.6 cause bot is too fast
		await get_tree().create_timer(0.6).timeout
		
		# AI is checking for the best move it can make
		var ai_board
		if difficulty == 2:
			ai_board = CheckersBot.minimax([GeneratePath.get_all_pieces(piece_array, DataHandler.Sides.ALL), [], 0], 1, DataHandler.Sides.BLACK)
		elif difficulty == 1:
			ai_board = CheckersBot.minimax([GeneratePath.get_all_pieces(piece_array, DataHandler.Sides.ALL), [], 0], 2, DataHandler.Sides.BLACK)
		elif difficulty == 0:
			ai_board = CheckersBot.minimax([GeneratePath.get_all_pieces(piece_array, DataHandler.Sides.ALL), [], 0], 3, DataHandler.Sides.BLACK)
		elif difficulty == 4:
			ai_board = CheckersBot.minimax([GeneratePath.get_all_pieces(piece_array, DataHandler.Sides.ALL), [], 0], 4, DataHandler.Sides.BLACK)
		# Algorithm is returning board Array with [piece_array[], move[piece_slot, move_slot, jump_slot], delta = value of the move]
		var move = ai_board[1]
		var piece_id = move[0]
		var move_id = move[1]
		
		# Appending legalmoves so AI could make that move
		legalMoves.append(move)
		
		# Need to wait 0.6 cause bot is too fast
		await get_tree().create_timer(0.6).timeout
		
		# Checking if game is still running if yes then change Sides
		if gamestart == true and aiGame == true:
			move_piece(piece_array[piece_id], move_id)
		
		if gamestart == true:
			whosMove = DataHandler.getNextSide(whosMove)
			if whosMove == DataHandler.Sides.WHITE:
				StatusLabel.text = "Ruch gracza białego!"
			else:
				StatusLabel.text = "Ruch gracza czarnego!"

# Logic for moving a piece
func move_piece(piece, location)-> void:
	if gamestart == false: return
	var pieceLocation = piece.slot_ID
	var move 
	
	# Checking if move is in legalMoves Array
	for m in legalMoves:
		if m[0] == pieceLocation and m[1] == location:
			move = m
			break
	var jump_id = move[2]
	
	
	# If move has jump_slot, delete piece from jump_slot if true
	if jump_id != null:
		piece_array[jump_id].queue_free()
		piece_array[jump_id] = -1
		
	
	# Basic animation for moving a piece
	var tween = get_tree().create_tween()
	tween.tween_property(piece, "global_position", grid_array[location].global_position + icon_offset, 0.2)
	
	# Removing piece from old_slot and placing it in new slot in piece_array
	piece_array[pieceLocation] = -1
	piece_array[location] = piece
	piece.slot_ID = location
	
	# If piece is on the other end make it a Queen
	if location >= 56 and location <= 63 and piece.type == DataHandler.PieceNames.BLACK_PAWN:
		piece.type = DataHandler.PieceNames.BLACK_QUEEN
		piece.load_icon(piece.type)
	elif location >= 0 and location <= 7 and piece.type == DataHandler.PieceNames.WHITE_PAWN:
		piece.type = DataHandler.PieceNames.WHITE_QUEEN
		piece.load_icon(piece.type)
	
	# Check if someone wins
	var winStatus = DataHandler.check_board_winner(GeneratePath.get_all_pieces(piece_array, DataHandler.Sides.ALL), whosMove)
	if winStatus != null:
		end_Game(winStatus)
	else:
		# Playing sound
		AudioPlayer.stream = pieceMoveSound
		AudioPlayer.play()
	
# Adding piece to a slot (Only using on the start of the game)
func add_piece(piece_type, location) -> void:
	# Making use of piece_scene and Adding as child to Board
	var new_piece = piece_scene.instantiate()
	board.add_child(new_piece)
	
	# Variables for the piece
	new_piece.type = piece_type
	new_piece.load_icon(piece_type)
	new_piece.global_position = grid_array[location].global_position + icon_offset
	
	# Set location of piece and connecting event
	piece_array[location] = new_piece
	new_piece.slot_ID = location
	new_piece.piece_selected.connect(_on_piece_selected)
	
# Logic for selecting a piece
func _on_piece_selected(piece):
	if piece_selected:
		# If piece is selected already then pass function
		_on_slot_clicked(grid_array[piece.slot_ID])
	elif gamestart == true:
		
		# Checking whos move is now. Need this for not moving other player piece
		match whosMove:
			DataHandler.Sides.WHITE:
				if piece.type == DataHandler.PieceNames.WHITE_PAWN or piece.type == DataHandler.PieceNames.WHITE_QUEEN:
					# Getting legalMoves for the piece
					legalMoves = GeneratePath.get_valid_moves(piece.slot_ID, piece.type, GeneratePath.get_all_pieces(piece_array, DataHandler.Sides.ALL))
					if legalMoves.size() > 0:
							piece_selected = piece
							# Set board filter for available moves
							set_board_filter(legalMoves)
			DataHandler.Sides.BLACK:
				if aiGame == false:
					if piece.type == DataHandler.PieceNames.BLACK_PAWN or piece.type == DataHandler.PieceNames.BLACK_QUEEN:
						# Getting legalMoves for the piece
						legalMoves = GeneratePath.get_valid_moves(piece.slot_ID, piece.type, GeneratePath.get_all_pieces(piece_array, DataHandler.Sides.ALL))
						if legalMoves.size() > 0:
								piece_selected = piece
								# Set board filter for available moves
								set_board_filter(legalMoves)

# Logic for setting filter for available slot to move
func set_board_filter(moveArray : Array):
	for move in moveArray:
		grid_array[move[1]].set_filter(DataHandler.slot_states.FREE)

# Logic for clearing filter
func clear_board_filter():
	for i in grid_array:
		i.set_filter()

# Fen Algorithm changed and used for making custom position for pieces
# https://en.wikipedia.org/wiki/Forsyth-Edwards_Notation
func parse_fen(fen_string : String) -> void:
	# Spliting parts of Fen string
	var boardstate = fen_string.split(" ")
	var board_index := 0
	
	# Logic for putting pieces at game start
	for i in boardstate[0]:
		if i == "/":continue
		if i.is_valid_int():
			board_index += i.to_int()
		else:
			add_piece(DataHandler.fen_dict[i], board_index)
			board_index += 1

# Clearing piece_array for next game
func clear_piece_array()->void:
	for i in piece_array:
		if i is Piece:
			# Need to free the node !!!
			# Without it node is staying in memory
			# Memory leaks !!
			i.queue_free()
	piece_array.fill(-1)
	
# Logic for ending the game and showing the winner
func end_Game(status : DataHandler.WinnerSide):
	gamestart = false
	aiGame = false
	difficultyDropDown.disabled = false
	playButton.disabled = false
	playWithAiButton.disabled = false
	difficultyDropDown.disabled = false
	resetButton.disabled = true
	if status == DataHandler.WinnerSide.WHITE:
		StatusLabel.text = "Wygrał gracz biały!"
	elif status == DataHandler.WinnerSide.BLACK:
		StatusLabel.text = "Wygrał gracz czarny!"
	elif status == DataHandler.WinnerSide.DRAW:
		StatusLabel.text = "Remis!"
		
	# Sound effects
	AudioPlayer.stream = endGameSound
	AudioPlayer.play()

# Event for button (PvP)
func _play_button_pressed():
	clear_piece_array()
	clear_board_filter()
	whosMove = DataHandler.Sides.WHITE
	StatusLabel.text = "Zaczyna gracz biały!"
	resetButton.disabled = false
	playButton.disabled = true
	playWithAiButton.disabled = true
	AudioPlayer.stream = startGameSound
	AudioPlayer.play()
	piece_selected = null
	parse_fen(fen)
	aiGame = false
	gamestart = true

# Event for button (PvAI)
func _play_ai_button_pressed():
	clear_piece_array()
	clear_board_filter()
	whosMove = DataHandler.Sides.WHITE
	difficultyDropDown.disabled = true
	resetButton.disabled = false
	playButton.disabled = true
	playWithAiButton.disabled = true
	StatusLabel.text = "Zaczyna gracz biały!"
	AudioPlayer.stream = startGameSound
	AudioPlayer.play()
	piece_selected = null
	parse_fen(fen)
	aiGame = true
	gamestart = true

# Closing app Logic
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()


func _on_difficulty_selected(index):
	difficulty = index
	if difficulty in [0, 1, 2]:
		fen = "1p1p1p1p/p1p1p1p1/1p1p1p1p/8/8/P1P1P1P1/1P1P1P1P/P1P1P1P1 w - 0 1"
	elif difficulty == 4:
		fen = "1p1p1p1p/p1p1p1p1/1q1q1q1q/8/8/P1P1P1P1/1P1P1P1P/P1P1P1P1 w - 0 1"


func _on_reset_button_pressed():
	AudioPlayer.stream = endGameSound
	AudioPlayer.play()
	clear_piece_array()
	clear_board_filter()
	StatusLabel.text = "Godot Checkers"
	whosMove = DataHandler.Sides.WHITE
	playButton.disabled = false
	playWithAiButton.disabled = false
	difficultyDropDown.disabled = false
	resetButton.disabled = true
	piece_selected = null
	aiGame = false
	gamestart = false
