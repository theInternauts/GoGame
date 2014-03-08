#these will eventually be attributes of a board object
BOARD_WIDTH = 3
BOARD_STATE = [2,2,0,2,2,2,0,0,1]


def breathing_room_total(options)
	board_index = options[:board_index]
	player_number = options[:player_number] || BOARD_STATE[board_index]
	previous_index = options[:previous_index] || board_index
	data = options[:data] || {:total => 0, :previous_indices => []}

	if off_board?({board_index: board_index, previous_index: previous_index})
		return data
	end
	puts "board_index is #{board_index}"

	data[:previous_indices].push(board_index)
	current_piece_number = BOARD_STATE[board_index]
	neighbors = [board_index + 1, board_index - 1, board_index + BOARD_WIDTH, board_index - BOARD_WIDTH] - data[:previous_indices]
	
	# puts "neighbors is #{neighbors}"
	if empty_index?(current_piece_number)
		data[:total] += 1
		return data[:total]
	elsif neighbors.empty? || oppents_piece?({current_piece_number: current_piece_number, player_number: player_number})
		return data[:total]
	else
		neighbors.each do |neighbor|
			unless data[:previous_indices].include?(neighbor)
				breathing_room_total( {player_number: player_number, board_index: neighbor, previous_index: board_index, data: data} )
			end
		end
	end
	return data[:total]
end



def empty_index?(current_piece_number)
	if current_piece_number == 0
		return true
	end
end

def oppents_piece?(options)
	current_piece_number = options[:current_piece_number]
	player_number = options[:player_number]
	if current_piece_number != player_number
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



p breathing_room_total( {board_index: 0} )
