#these will eventually be attributes of a board object
BOARD_WIDTH = 5
BOARD_STATE = [	2,2,2,2,2,
								2,0,0,0,2,
								2,0,0,0,2,
								2,0,0,0,2,
								2,2,2,2,2	]
BOARD_STATE.map! do |num|
	if num == 2
		num = :black
	elsif num == 1
		num = :white
	elsif num == 0
		num = :empty
	end
end
p BOARD_STATE
			


def breathing_room_total(options)
	board_index = options[:board_index]
	player_color = options[:player_color] || BOARD_STATE[board_index]
	previous_index = options[:previous_index] || board_index
	data = options[:data] || {:breathing_room_total => 0, :previous_indices => [], :indices_of_target_player_color => []}

	# p data[:previous_indices].sort

	if off_board?({board_index: board_index, previous_index: previous_index})
		return data
	end
	puts "board_index is #{board_index}"

	data[:previous_indices].push(board_index)
	current_piece_color = BOARD_STATE[board_index]
	neighbors = [board_index + 1, board_index - 1, board_index + BOARD_WIDTH, board_index - BOARD_WIDTH] - data[:previous_indices]


	if empty_index?(current_piece_color)
		data[:breathing_room_total] += 1
		return data[:breathing_room_total]
	elsif neighbors.empty? || oppents_piece?({current_piece_color: current_piece_color, player_color: player_color})
		return data[:breathing_room_total]
	elsif player_color == current_piece_color
		data[:indices_of_target_player_color].push(board_index)
		neighbors.each do |neighbor|
			unless data[:previous_indices].include?(neighbor)
				breathing_room_total( {player_color: player_color, board_index: neighbor, previous_index: board_index, data: data} )
			end
		end
	end
	return data
end

#if data[:breathing_room_total] is zero or, and a player is attempting to make this move, the move is illegal
#if the total is zero, after a legal move, the player who made the move gets data[:indices_of_target_player_color].length points SHITTY VARIABLE NAME
#for their capture, and each piece in the indices_of_target_player_color array gets removed from the board

# def find_score(scores)
# 	unchecked_spaces = (0..(BOARD_WIDTH * BOARD_WIDTH - 1)).to_a
# 	white_score = scores[:white] || 0
# 	black_score = scores[:black] || 0
# 	while !unchecked_spaces.empty?
# 		surrounded_territory = true
# 		current_piece_color = unchecked_spaces.first

# 	end
# end


def empty_index?(current_piece_color)
	if current_piece_color == :empty
		return true
	end
end

def oppents_piece?(options)
	current_piece_color = options[:current_piece_color]
	player_color = options[:player_color]
	if current_piece_color != player_color && current_piece_color != :empty
		return true
	end
end

def off_board?(options)
	board_index = options[:board_index]
	previous_index = options[:previous_index]
	if negative_index?(board_index) || index_above_board_length?(board_index) || different_row_and_column?(options)
		return true
	else
		return false
	end
end

def negative_index?(board_index)
	if board_index < 0
		return true
	end
end

def index_above_board_length?(board_index)
	if board_index > BOARD_WIDTH * BOARD_WIDTH
		return true
	end
end

def different_row_and_column?(options)
	board_index = options[:board_index]
	previous_index = options[:previous_index]
	if board_index % BOARD_WIDTH != previous_index % BOARD_WIDTH && board_index / BOARD_WIDTH != previous_index / BOARD_WIDTH
		return true
	end
end

# BOARD_STATE = [	2,2,0,0,0,
# 								2,2,2,2,0,
# 								2,2,2,2,0,
# 								0,2,0,2,2,
# 								0,2,2,2,0	]
#why isn't the above example ever checking index 25?

p breathing_room_total( {board_index: 0} )





