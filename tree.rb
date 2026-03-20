require 'pry-byebug'
require_relative 'node.rb'
  
  class Tree < Node

    attr_accessor :array, :root, :new_tree_array

    def initialize(array)
      @array = array.uniq.sort
      @mid = @array.length / 2
      @root = @array[@mid]
      @left = @array[0..@mid - 1]
      @right = @array[@mid + 1..-1]
      @parent = nil
      @new_tree_array = []
    end

    def new_tree_array
      @new_tree_array
    end

    def build_tree(array)

      if array.length < 1
        return nil
      end
      
      midpoint = array.length / 2
      root = array[midpoint]
      node = Node.new(root, array)
      node.left = build_tree(node.left)
      node.right = build_tree(node.right)
      node
    end

    def pretty_print(node = @root, prefix = '', is_left: true)
    return unless node
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", is_left: false)
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.root}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", is_left: true)
    end
    
    def include?(value)
    # binding.pry
    included = false
    if @root == nil
      return nil
    elsif @root == value
      return true
    end
    included = @root.left.include?(value) if @root.left != nil
    return true if included == true   
    included = @root.right.include?(value) if @root.right != nil
    included
  end

  def insert(value)
    return puts "#{value} is already in tree" if include?(value) == true
  # binding.pry
    current = @root
    @left = @root.left
    @right = @root.right
    direction = ""
    inserted = false

      until inserted == true
        # binding.pry
        left = current.left
        right = current.right
        if value < current.root
          direction = "left"
        elsif value > current.root
          direction = "right"
        end
        if direction == "left" && left.nil?
          # binding.pry
          node = Node.new(value, [value])
          node.left = nil
          node.right = nil
          current.left = node
          inserted = true
          return
        elsif direction == "right" && right.nil?
          # binding.pry
          node = Node.new(value, [value])
          node.left = nil
          node.right = nil
          current.right = node
          inserted = true
          return
        elsif direction == "left"
          current = left
        elsif direction == "right"
          current = right
        end
      end
    end

    def delete(value)
      puts "#{value} not found in array" if include?(value).nil?
      # current = find_node(value)
      current = @root
      found = false
      level = 0
      @parent = @root

      until found == true
        # binding.pry
        if value == current.root
          found = true
        elsif value < current.root
          # binding.pry
          @parent = current
          current = current.left
        elsif value > current.root
          # binding.pry
          @parent = current
          current = current.right
        end
      end


      #for no children
      if current.left.nil? && current.right.nil?
        @parent.left = current.left if current.left != nil
        @parent.left = current.right if current.right != nil

      #For one child
      elsif current.left.nil? || current.right.nil?
        if @parent.root > value
          # binding.pry
          @parent.left = current.left if current.left != nil
          @parent.left = current.right if current.right != nil
        else
          # binding.pry
          @parent.right = current.left if current.left != nil
          @parent.right = current.right if current.right != nil
        end
        current = nil
      else
      # For 2 children
      switch_node = current.right
      # binding.pry
      while switch_node.left != nil
        # binding.pry
        if switch_node.left.root < switch_node.root
          # binding.pry
          switch_parent = switch_node
          switch_node = switch_node.left
        end
      end
      if value < @parent.root
        @parent.left = switch_node
        switch_parent.left = nil
        switch_node.right = current.right
        switch_node.left = current.left
        current = nil
      elsif value > @parent.root
        @parent.right = switch_node
        switch_parent.left = nil
        switch_node.right = current.right
        switch_node.left = current.left
        current = nil
      elsif value == @parent.root
        # binding.pry
        left = current.left
        right = current.right
        child_left = switch_node.left
        child_right = switch_node.right
        current.left = current.right = nil
        switch_parent.left = nil
        switch_node.left = left
        switch_node.right = right
        @root = switch_node
        insert(child_left.root) if child_left != nil
        insert(child_right.root) if child_right != nil
        current = nil
      end
    end
    end

    def level_order
      return enum_for(:level_order) unless block_given?  
      @queue = []
      @queue.push(@root)

      while @queue != []
        node = @queue.shift
        yield node.root
        @queue.push(node.left) if node.left != nil
        @queue.push(node.right) if node.right != nil
      end
    end

    def preorder
      return enum_for(:preorder) unless block_given?
      # binding.pry    
      if @root.nil?
        return nil
      end

      yield @root.root
      @root.left.preorder { |root| print "#{root}, " } if @root.left != nil
      @root.right.preorder { |root| print "#{root}, " } if @root.right != nil
      print "fin"
    end

    def inorder
      binding.pry
      return enum_for(:inorder) unless block_given?
      if @root.nil?
        return nil
      end
      
      @root.left.inorder{ |val| @@new_tree_array.push(val) } if @root.left != nil
      yield @root.root
      @root.right.inorder{ |val| @@new_tree_array.push(val) } if @root.right != nil
      print "fin"
    end

    def postorder
      return enum_for(:postorder) unless block_given?
      
      if @root.nil?
        return nil
      end
      value_left = @root.left.postorder { |val| @@new_tree_array.push(val) } if @root.left != nil
      value_right = @root.right.postorder { |val| @@new_tree_array.push(val) } if @root.right != nil
      # binding.pry
      @new_tree_array = @@new_tree_array
      yield @root.root
      print "fin"
    end

    def find_node(value)
      current = @root
      found = false
      level = 0
      @parent = @root

      until found == true
          # binding.pry
        if value == current.root
          found = true
        elsif value < current.root
          # binding.pry
          @parent = current
          current = current.left
        elsif value > current.root
          # binding.pry
          @parent = current
          current = current.right
        end
      end
      current
    end

    def count_nodes_down(current_node)
      if current_node.nil?
        return 0
      end
      height_left = 0
      height_right = 0
      # binding.pry
      height_left = count_nodes_down(current_node.left) if current_node.left != nil
      height_left += 1 
      height_right = count_nodes_down(current_node.right) if current_node.right != nil
      height_right += 1
      if height_left > height_right
        return height_left
      else
        return height_right
      end
    end

    def height(value)
      if include?(value) == false
        puts "#{value} is not in the tree"
        return nil
      end
      # binding.pry
      node = find_node(value)
      height = count_nodes_down(node) - 1
      height
    end

    def depth(value)
      if include?(value) == false
        puts "#{value} is not in the tree"
        return nil
      end
      depth = 0
      current = @root
      until current.root == value
        if value < current.root
          current = current.left
          depth += 1
        elsif value > current.root
          current = current.right
          depth += 1
        end
      end
      puts "Depth value found is #{depth}"
      depth
    end

    def balanced?
      # binding.pry
      current = @root
      balanced_left = current.left.balanced?
      balanced_right = current.right.balanced?
      return false if balanced_left == false || balanced_right == false
      height_left_side = height(current.left.root)
      height_right_side = height(current.right.root)
      height_difference = height_right_side - height_left_side

      if height_difference < -1 || height_difference > 1
        return false
      else
        return true
      end
    end

    def rebalance(array)
      binding.pry
      new_array = array.uniq.sort
      new_tree = Tree.new(new_array)
      @root = new_tree.build_tree(new_tree.array)
      # binding.pry
    end
  end

test = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
test.root = test.build_tree(test.array)
test.pretty_print
puts test.include?(23)
puts test.include?(6344)
test.insert(20)
test.pretty_print
# test.insert(20)
# puts "test delete 1"
# test.delete(1)
test.pretty_print 
# test.delete(8)
# test.pretty_print
display_root = -> (root) { puts root }
test.level_order(&display_root)
test.level_order
# puts "test preorder:"
# test.preorder(&display_root)
# puts "Next test inorder"
# test.inorder(&display_root)
# puts "Next test postorder:"
# test.postorder(&display_root)
puts "next test height"
# test.height(67)
test.depth(67)
test.depth(1)
puts test.balanced?
# binding.pry
test.postorder{ |val| test.new_tree_array.push(val) }
puts "new_tree_array is #{test.new_tree_array}"
new_tree = test.rebalance(test.new_tree_array)
test.pretty_print

tree_two = Tree.new(Array.new(15) { rand(1..100) })
tree_two.root = tree_two.build_tree(tree_two.array)
tree_two.pretty_print
puts "Is the tree balanced?"
puts tree_two.balanced?
tree_two.insert(160)
tree_two.insert(800)
tree_two.insert(555)
tree_two.insert(105)
tree_two.pretty_print
puts "Is the tree balanced?"
puts tree_two.balanced?
puts "Let's rebalance it!!!"
tree_two.postorder{ |val| tree_two.new_tree_array.push(val) }
tree_two.rebalance(tree_two.new_tree_array)
tree_two.pretty_print