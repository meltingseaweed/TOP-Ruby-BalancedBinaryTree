require 'pry-byebug'
class Node

  attr_accessor :root, :left, :right
  @@new_tree_array = []
  def initialize(root, arr)
    @mid = arr.length / 2
    @root = root
    @left = arr[0...@mid]
    @right = arr[@mid + 1..-1]
    @parent
    
    @to_array = -> (val) { @new_tree_array << val }
  end

  def root
    @root
  end

  def left
    @left
  end

  def right
    @right
  end
  
  def include?(value)
    # binding.pry
    included = false
    if @root == nil
      return nil
    elsif @root == value
      return true
    end
    included = @left.include?(value) if @left != nil
    return true if included == true  
    included = @right.include?(value) if @right != nil
    included
  end

  def preorder
    return enum_for(:preorder) unless block_given?
    # binding.pry
    if @root.nil?
      return nil
    end
    yield @root
    @left.preorder { |root| print "#{root}, " } if @left != nil
    @right.preorder { |root| print "#{root}, " } if @right != nil
  end

  def inorder
    binding.pry
    return enum_for(:inorder) unless block_given?  
    if @root.nil?
      return nil
    end
    # binding.pry
    @left.inorder{ |val| @@new_tree_array.push(val) } if @left != nil
    yield @root
    @right.inorder{ |val| @@new_tree_array.push(val) } if @right != nil
  end

  def postorder
    return enum_for(:postorder) unless block_given?  
    if @root.nil?
      return nil
    end
    # binding.pry
    @left.postorder { |val| @@new_tree_array.push(val) } if @left != nil
    @right.postorder { |val| @@new_tree_array.push(val) } if @right != nil
    yield @root
  end

  def balanced?
    # binding.pry
    balanced_left = @left.balanced? if @left != nil
    balanced_right = @right.balanced? if @right != nil
    return false if balanced_left == false || balanced_right == false

    height_left_side = height(@left) if @left != nil
    height_right_side = height(@right) if @right != nil
    height_left_side = 0 if @left.nil?
    height_right_side = 0 if @right.nil?
    height_difference = height_right_side - height_left_side

    if height_difference < -1 || height_difference > 1
      return false
    else
      return true
    end
  end

  def find_node(value)
    found = false
    @parent = @root

    until found == true
        # binding.pry
      if value == @root
        found = true
      elsif value < @root
        # binding.pry
        @parent = self
        current = @left
      elsif value > @root
        # binding.pry
        @parent = self
        current = @right
      end
    end
    current
  end

  def count_nodes_down(current_node)
    if current_node.left.nil? && current_node.right.nil?
      return 1
    end
    height_left = 0
    height_right = 0
    # binding.pry
    if current_node.left != nil
      # binding.pry
      height_left = count_nodes_down(current_node.left) 
      height_left += 1 
    end
    if current_node.right != nil
      height_right = count_nodes_down(current_node.right)
      height_right += 1
    end
    if height_left > height_right
      return height_left
    else
      return height_right
    end
  end

  def height(node)
    # binding.pry
    if node.left != nil || node.right != nil
      height = count_nodes_down(node)
    else 
      height = 1
    end
    height
  end

end