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

end

test = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
test.root = test.build_tree(test.array)
test.pretty_print
puts test.include?(23)
puts test.include?(6344)
test.insert(20)
test.pretty_print
test.insert(20)