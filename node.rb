class Node

  attr_accessor :root, :left, :right

  def initialize(root, arr)
    @mid = arr.length / 2
    @root = root
    @left = arr[0...@mid]
    @right = arr[@mid + 1..-1]
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

end