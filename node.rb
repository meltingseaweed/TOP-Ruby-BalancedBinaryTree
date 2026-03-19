require 'pry-byebug'
class Node

    attr_accessor :root, :left, :right

    def initialize(root, arr)
      @mid = arr.length / 2
      @root = root
      @left = arr[0...@mid]
      @right = arr[@mid + 1..-1]
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
      @right.preorder { |root| puts root } if @right != nil
    end

    def inorder
      return enum_for(:inorder) unless block_given?  
      if @root.nil?
        return nil
      end
      # binding.pry
      @left.inorder { |root| print "#{root}, " } if @left != nil
      yield @root
      @right.inorder { |root| print "#{root}, " } if @right != nil
    end

    def postorder
      return enum_for(:postorder) unless block_given?  
      if @root.nil?
        return nil
      end
      # binding.pry
      @left.inorder { |root| print "#{root}, " } if @left != nil
      @right.inorder { |root| print "#{root}, " } if @right != nil
      yield @root
    end

  end