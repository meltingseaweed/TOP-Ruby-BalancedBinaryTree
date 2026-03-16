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
end

test = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
test.root = test.build_tree(test.array)
test.pretty_print