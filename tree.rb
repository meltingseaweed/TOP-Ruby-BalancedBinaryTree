require 'pry-byebug'
require_relative 'node.rb'
  
  class Tree < Node

    attr_reader :array

    def initialize(array)
      @array = array.uniq.sort
      @mid = @array.length / 2
      @root = @array[@mid]
      @left = @array[0..@mid - 1]
      @right = @array[@mid + 1..-1]
      @parent = nil
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
        current = nil
        return
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
        return
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
        # switch_node.left = nil if switch_node.left != nil
        # switch_node.right = nil if switch_node.right != nil
        switch_node.left = left
        switch_node.right = right
        @root = switch_node
        insert(child_left.root) if child_left != nil
        insert(child_right.root) if child_right != nil
        #how to switch if it has children...?
        # Store roots left and right values into "l"eft" and "right"
        #Disconnect root. 
        #Disconnect switch node
        #connect switch node to previous roots left and right.
        # Use insert to re-insert any of switch_nodes children.
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
      return enum_for(:inorder) unless block_given?
      
      if @root.nil?
        return nil
      end
      @root.left.inorder { |root| print "#{root}, " } if @root.left != nil
      yield @root.root
      @root.right.inorder { |root| print "#{root}, " } if @root.right != nil
      print "fin"
    end

    def postorder
      return enum_for(:postorder) unless block_given?
      
      if @root.nil?
        return nil
      end
      value_left = @root.left.postorder { |root| print "#{root}, " } if @root.left != nil
      value_right = @root.right.postorder { |root| print "#{root}, " } if @root.right != nil
      yield @root.root
      print "fin"
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
# test.delete(4)
test.pretty_print 
# test.delete(8)
# test.pretty_print
display_root = -> (root) { puts root }
test.level_order(&display_root)
test.level_order
puts "test preorder:"
test.preorder(&display_root)
puts "Next test inorder"
test.inorder(&display_root)
puts "Next test postorder:"
test.postorder(&display_root)