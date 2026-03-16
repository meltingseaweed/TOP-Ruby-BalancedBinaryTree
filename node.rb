class Node

  attr_accessor :root, :left, :right

  def initialize(root, arr)
    @mid = arr.length / 2
    @root = root
    @left = arr[0..@mid - 1]
    if arr.length == 1
      @left = []
    end
    @right = arr[@mid + 1..-1]
  end

  def left
    @left
  end

  def right
    @right
  end
  
end