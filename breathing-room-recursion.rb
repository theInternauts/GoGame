#these will eventually be attributes of a board object
BOARD_WIDTH = 5
BOARD_STATE = [	2,2,2,2,2,
								2,0,2,0,2,
								2,2,1,0,2,
								2,1,0,1,2,
								2,2,1,2,2	]
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

# if data[:breathing_room_total] is zero or, and a player is attempting to make this move, the move is illegal
# if the total is zero, after a legal move, the player who made the move gets data[:indices_of_target_player_color].length points SHITTY VARIABLE NAME
# for their capture, and each piece in the indices_of_target_player_color array gets removed from the board

def find_score(scores)
	#expects input of a hash with pointers :white, and :black, pointing to the respective team's scores
	unchecked_spaces = (0..(BOARD_WIDTH * BOARD_WIDTH - 1)).to_a
	while !unchecked_spaces.empty?
		info = recursion({ board_index: unchecked_spaces.first,
											data: {surrounded_territory: true} })
		if info[:surrounded_territory] && info[:border_color]
			scoring_team = info[:border_color]
			scores[scoring_team] += info[:total]
		end
		unchecked_spaces = unchecked_spaces - info[:previous_indices]
	end
	return scores
end

def recursion(options)
	board_index = options[:board_index]
	current_piece_color = BOARD_STATE[board_index]
	previous_index = options[:previous_index] || board_index

	#seems like keep the variables contained within data, and just returning data would be more readable
	#and easier to modify without breaking, but i wanted to see it the other way so i tried this
	#mostly because it looked weird in the last recursion to keep indexing into data, but i think this is worse
	#
	#keeping the commented out assignments below because i still want to see why it didn't work that way
	#pretty sure it should, just think failure to make it work was an indication that it was unreadable
	#
	# surrounded_territory = options[:data][:surrounded_territory]
	# previous_indices = options[:data][:previous_indices] || []
	# border_color = options[:data][:border_color]
	# total = options[:data][:total] || 0
	data = options[:data]
	data[:previous_indices] ||= []
	data[:total] ||= 0
	# puts "board_index is #{board_index}"

	data[:previous_indices].push(board_index)
	if current_piece_color != :empty && data[:previous_indices].empty?
		# puts "hi"
		return	data
	end

	if off_board?({board_index: board_index, previous_index: previous_index})
		# puts "hey"
		return data
	end

	if current_piece_color == :empty
		# puts "ho"
		data[:total] += 1
		# puts "data[:total] is #{data[:total]}"
		neighbors = [board_index + 1, board_index - 1, board_index + BOARD_WIDTH, board_index - BOARD_WIDTH] - data[:previous_indices]
		neighbors.each do |neighbor|
			unless data[:previous_indices].include?(neighbor)
				recursion( {board_index: neighbor, previous_index: board_index, data: data } )
			end
		end
	elsif !data[:border_color]
		# puts "HIII"
		# puts "data[:border_color] is #{data[:border_color]}"
		data[:border_color] = current_piece_color
		# puts "data[:border_color] is #{data[:border_color]}"
		return	data
	elsif data[:border_color] != current_piece_color
		# puts "hello"
		data[:surrounded_territory] = false
		return	data
	elsif data[:border_color] == current_piece_color
		# puts "go fuck yourself"
		return	data
	end
	return	data
				 
end




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

# p breathing_room_total( {board_index: 0} )
p find_score(:black => 0, :white => 0)



