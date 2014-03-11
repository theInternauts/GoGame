#these will eventually be attributes of a board object
BOARD_WIDTH = 5
BOARD_STATE = [	2,2,2,2,2,
								2,0,0,2,2,
								2,2,2,1,1,
								2,1,1,0,0,
								2,1,0,0,0	]
BOARD_STATE.map! do |num|
	if num == 2
		num = :black
	elsif num == 1
		num = :white
	elsif num == 0
		num = :empty
	end
end
			

def breathing_room_total(options)
	board_index = options[:board_index]
	player_color = options[:player_color] || BOARD_STATE[board_index]
	previous_index = options[:previous_index] || board_index
	data = options[:data] || {:breathing_room_total => 0, :previous_indices => [], :indices_of_target_player_color => []}

	if off_board?({board_index: board_index, previous_index: previous_index})
		return data
	end

	data[:previous_indices].push(board_index)
	current_piece_color = BOARD_STATE[board_index]
	neighbors = find_neighbors({board_index: board_index, previous_indices: data[:previous_indices]})

	#if either neighbors is empty, or current_piece_color doesn't equal player_color we have hit a base case in which we augment nothing, so it doesn't have a conditional
	if empty_index?(current_piece_color)
		data[:breathing_room_total] += 1
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

# if data[:breathing_room_total] is zero or, and a player is attempting to make this move, the move is illegal
# if the total is zero, after a legal move, the player who made the move gets data[:indices_of_target_player_color].length points SHITTY VARIABLE NAME
# for their capture, and each piece in the indices_of_target_player_color array gets removed from the board

def find_score(scores)
	#expects input of a hash with pointers :white, and :black, pointing to the respective team's scores
	unchecked_spaces = (0..(BOARD_WIDTH * BOARD_WIDTH - 1)).to_a
	while !unchecked_spaces.empty?
		info = search_for_captured_territory({ board_index: unchecked_spaces.first,
											data: {surrounded_territory: true} })

		if info[:surrounded_territory] && info[:border_color]
			scoring_team = info[:border_color]
			scores[scoring_team] += info[:total]
		end
		unchecked_spaces = unchecked_spaces - info[:previous_indices]
	end
	return scores
end

def search_for_captured_territory(options)
	board_index = options[:board_index]
	current_piece_color = BOARD_STATE[board_index]
	previous_index = options[:previous_index] || board_index

	data = options[:data]
	data[:previous_indices] ||= []
	data[:total] ||= 0

	data[:previous_indices].push(board_index)

	if off_board?({board_index: board_index, previous_index: previous_index})
		return data
	end

	#if border_color equals current_piece_color, we have hit a base case where we augment nothing, so it doesn't have a conditional
	if current_piece_color == :empty
		data[:total] += 1
		neighbors = find_neighbors({board_index: board_index, previous_indices: data[:previous_indices]})
		neighbors.each do |neighbor|
			unless data[:previous_indices].include?(neighbor)
				search_for_captured_territory( {board_index: neighbor, previous_index: board_index, data: data } )
			end
		end
	elsif !data[:border_color]
		data[:border_color] = current_piece_color
		#the next condition indicates that the set of empty spaces is not surrounded by just a single color, so isn't captured territory
	elsif data[:border_color] != current_piece_color
		data[:surrounded_territory] = false
	end

	return	data			 
end


def find_neighbors(options)
	board_index = options[:board_index]
	previous_indices = options[:previous_indices]
	return [board_index + 1, board_index - 1, board_index + BOARD_WIDTH, board_index - BOARD_WIDTH] - previous_indices
end

def empty_index?(current_piece_color)
	if current_piece_color == :empty
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

# p breathing_room_total( {board_index: 1} )
p find_score(:black => 0, :white => 0)



