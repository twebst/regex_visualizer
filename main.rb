require 'ruby2d'

set background: 'white'
set title: 'Regex Generator'
set resizable: true

def dist(x1, y1, x2, y2)
  Math.sqrt((x1 - x2)**2 + (y1 - y2)**2)
end

class StateLise
  class Node
    attr_accessor :state, :next, :prev

    def initialize(state)
      @state = state
    end
  end

  attr_accessor :head

  def new_head(node)
    if node.prev then node.prev.next = node.next end
    if node.next then node.next.prev = node.prev end
    if self.head then self.head.prev = node end
    node.next = self.head
    node.prev = nil
    self.head = node
  end

  def each
    current_node = head
    while current_node
      yield current_node
      current_node = current_node.next
    end
  end
end

class State 
  @@radius = 100
  @@border_radius = @@radius * 1.1 # 10% bigger
  @@color = 'red'
  @@border_color = 'black'

  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def draw
    Circle.new(x: @x, y: @y, radius: @@border_radius, color: @@border_color)
    Circle.new(x: @x, y: @y, radius: @@radius, color: @@color)
  end

  def intersect?(event_x, event_y)
    dist(@x, @y, event_x, event_y) <= @@radius
  end
end

@states = []
@grabbed_state = nil

on :mouse_down do |event|
  case event.button
  when :right
    @states.push(State.new(event.x, event.y))
  when :left
    @states.each do |state|
      if !@grabbed_state && state.intersect?(event.x, event.y)
        @grabbed_state = state
      end
    end
  end
end

on :mouse_up do
  @grabbed_state = nil
end

on :mouse_move do |event|
  if @grabbed_state
    @grabbed_state.x = event.x
    @grabbed_state.y = event.y
  end
end

update do
  clear
  @states.each(&:draw)
end

show
