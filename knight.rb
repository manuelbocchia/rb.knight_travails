# Assignment

# Your task is to build a function knight_moves that shows the shortest possible way to get from one square to another by outputting all squares the knight will stop on along the way.

# You can think of the board as having 2-dimensional coordinates. Your function would therefore look like:

#     knight_moves([0,0],[1,2]) == [[0,0],[1,2]]
#     knight_moves([0,0],[3,3]) == [[0,0],[1,2],[3,3]]
#     knight_moves([3,3],[0,0]) == [[3,3],[1,2],[0,0]]

#     Put together a script that creates a game board and a knight.
#     Treat all possible moves the knight could make as children in a tree. Don’t allow any moves to go off the board.
#     Decide which search algorithm is best to use for this case. Hint: one of them could be a potentially infinite series.
#     Use the chosen search algorithm to find the shortest path between the starting square (or node) and the ending square. Output what that full path looks like, e.g.:

#   > knight_moves([3,3],[4,3])
#   => You made it in 3 moves!  Here's your path:
#     [3,3]
#     [4,5]
#     [2,4]
#     [4,3]

class Gameboard
    attr_accessor :board
    def initialize
        make_board
    end

    def make_board
        w = "■"
        b = "□"
        line1 = []
        line2 = []
        4.times do 
            line1 << w.dup
            line1 << b.dup
        end
        4.times do
            line2 << b.dup
            line2 << w.dup
        end
        @board = []
        4.times do
            board << line1.dup
            board << line2.dup
        end
    end

    def draw_board
        drawn = board.map.with_index {|line, index| "#{index} #{line.join(" ")}\n"}
        drawn.unshift("  0 1 2 3 4 5 6 7")
        drawn
    end

    def place_knight(coord = [0,0])
        knight = "\e[45m♘\e[0m"
        y = coord[1]
        x = coord[0]
        board[x][y] = knight
    end

end

newBoard = Gameboard.new
newBoard.place_knight([5,4])

puts newBoard.draw_board




