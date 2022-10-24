# Assignment

# Your task is to build a function knight_moves that shows the shortest possible way to get from one square to another by outputting all squares the knight will stop on along the way.

# You can think of the parent as having 2-dimensional coordinates. Your function would therefore look like:

#     knight_moves([0,0],[1,2]) == [[0,0],[1,2]]
#     knight_moves([0,0],[3,3]) == [[0,0],[1,2],[3,3]]
#     knight_moves([3,3],[0,0]) == [[3,3],[1,2],[0,0]]

#     Put together a script that creates a game parent and a knight.
#     Treat all possiblemoves the knight could make as children in a tree. Don’t allow anymoves to go off the parent.
#     Decide which search algorithm is best to use for this case. Hint: one of them could be a potentially infinite series.
#     Use the chosen search algorithm to find the shortest path between the starting square (or node) and the ending square. Output what that full path looks like, e.g.:

#   > knight_moves([3,3],[4,3])
#   => You made it in 3moves!  Here's your path:
#     [3,3]
#     [4,5]
#     [2,4]
#     [4,3]


# A class of knight which creates Knight objects. These knights can get coordinates and calculate their ownmoves.

# class Knight
#     @moves = []
#     attr_accessor :start, :finish, :queue, :steps, :moves, :root
#     @@steps = 0
#     @@big_queue = []
#     @@root = []
    
#     def initialize(start = [0,0], finish = [0,0])
#         @start = start
#         @finish = finish
#         pot_moves
#         @queue = []
#         @result = []
#     end

#     def build_tree()
#         @@big_queue << start
#         @@big_queue.each do |coord|
#             unless @@root.any? {|node| node.start == coord }
#                 node = Knight.new(coord)
#                 node.moves.each do |arr|
#                     unless @@big_queue.any? arr
#                     @@big_queue << arr
#                     end
#                 end
#                 @@root << node
#             end
#             @@root
#         end
#     end
    
#     def root
#         @@root
#     end

#     def pot_moves(start = @start)
#         changes = [[-1,-2],[1,2],[-2,-1],[2,1],[1,-2],[-1,2],[2,-1],[-2,1]]
#         start = start
#         @moves = changes.map {|sum| [start[0]+sum[0],start[1]+sum[1]]}.filter {|item| item[0] < 8 && item[1] < 8 && item[0] >= 0 && item[1] >= 0}
#         @moves
#     end

#     def calc_moves(start=@start, finish=@finish)

#         @queue << start
        
#         @queue.each do |num|
#             unless @queue.any? finish
#                 node1 = root.find {|item| item.start == num}
#                 node1.moves.each do |move|
#                 unless @queue.any?(move) ||@queue.any?(finish)
#                     @queue << move
#                 end
#             end
#         end
#     end
#         @queue
#     end

class Node
    attr_accessor :root, :children, :parent, :square
    @parent = nil
    @root = []
    
    def initialize(x, y, parent = @parent)
        @square = Square.new(x, y)
    end

    # def child_nodes(start = [@square.x,@square.y], parent = @parent)
    #     changes = [[-1,-2],[1,2],[-2,-1],[2,1],[1,-2],[-1,2],[2,-1],[-2,1]]
    #     @children = changes.map {|sum| Node.new(start[0]+sum[0],start[1]+sum[1], self)}.filter {|item| item.square.x < 8 && item.square.y < 8 && item.square.x >= 0 && item.square.y >= 0}
    #     @children
    # end

    def child_nodes(root = @square)
        potentials = []
        potentials.push(
          [root.x + 2, root.y + 1],
          [root.x + 2, root.y - 1],
          [root.x + 1, root.y + 2],
          [root.x + 1, root.y - 2],
          [root.x - 2, root.y + 1],
          [root.x - 2, root.y - 1], 
          [root.x - 1, root.y + 2], 
          [root.x - 1, root.y - 2]
          )
      
        valid_children = potentials.select do |space|
          space[0].between?(0,8) &&
          space[1].between?(0,8)
        end
      
        valid_children = valid_children.map do |space|
          Node.new(space[0], space[1], self)
        end
        @children = valid_children
      end

end

class Square
    attr_accessor :x, :y
    
    def initialize(x,y)
        @x = x
        @y = y
    end

    def ==(other)
        [self.x, self.y] == [other.x, other.y]
      end
    
    def to_s
        [self.x, self.y].to_s
    end
end

def knight_moves(first_square,final_square)
    first_children = Node.new(first_square[0],first_square[1])
    first_children.child_nodes
    bfs(final_square, first_children.children)
end

def bfs(search, children)
    queue = children

    coord = Square.new(search[0],search[1])

    loop do 
        current = queue.shift
        if current.square === coord
            make_path(current)
            break
        else
            current.child_nodes.each {|child| queue << child}
        end
    end
end

def make_path(current)
    parent = current.parent
    array = []
    while !parent.nil?
        array << [parent.square.x, parent.square.y]
        parent = parent.parent
    end
    array.reverse!
    array << [current.square.x, current.square.y]
    puts "Here's your path."
    array.each {|step| p step}
end





# The gameparent class creates gameparents. It makes an empty parent as an array to be modified later, and has a draw parent function that formats the parent neatly to be seen in the terminal. This class also has two methods, one to place the knight on the parent, and one to place themoves the knight can potentially make.

class Gameparent
    attr_accessor :parent
    def initialize
        make_parent
    end

    def make_parent
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
        @parent = []
        4.times do
            parent << line1.dup
            parent << line2.dup
        end
    end

    def draw_parent
        @drawn = parent.map.with_index {|line, index| "#{index} #{line.join(" ")}\n"}
        @drawn.unshift("  0 1 2 3 4 5 6 7")
        @drawn
    end

    # def place_knight(coord = [0,0])
    #     knight = "\e[36m\e[45m♘\e[0m\e[0m"
    #     y = coord[1]
    #     x = coord[0]
    #     parent[x][y] = knight
    # end

    # def place_moves(array)
    #     moving = "\e[30m\e[42mX\e[0m\e[0m"
    #     array.each  do |coord|
    #         y = coord[1]
    #         x = coord[0]
    #         parent[x][y] = moving
    #     end
    #     draw_parent
    # end

end

# newparent = Gameparent.new

# newKnight = Knight.new([0,0],[1,1])

# newparent.draw_parent

# puts newparent.place_moves(newKnight.pot_moves)

# p newKnight.build_tree

# p newKnight.calc_moves

newNode = Node.new(0,0)

p knight_moves([0,0],[2,2])