require_relative "buffered_hash"
require_relative "patch"

module Microworlds
  class World
    def initialize(size)
      @size = size
      @patches = (@size**2).times.map do |i| 
                BufferedHash.new(:xpos  => i % @size,
                                 :ypos  => i / @size,
                                 :color => :black)
              end

      @creatures = 10.times.map { BufferedHash.new(:xpos     => rand(0...@size),
                                                   :ypos     => rand(0...@size),
                                                   :heading  => 0,
                                                   :color    => :red) }
    end

    attr_reader :patches, :creatures

    def update_patch(x, y)
      patch = @patches[index_for(x, y)]

      yield Patch.new(patch, neighbors_for(patch))
      patch.commit
    end

    def each_patch
      @patches.each { |e| yield(Patch.new(e, neighbors_for(e))) } 

      @patches.each { |e| e.commit }
    end

    def each_creature
      @creatures.each { |e| yield(e) }

      @creatures.each { |e| e.commit }
    end

    def neighbors_for(e)
      xpos = e[:xpos]
      ypos = e[:ypos]


      offsets = [[0,1],[1,0],[0,-1],[-1,0],
                 [1,1],[-1,-1],[-1,1],[1,-1]]
      
      offsets.map do |dx, dy|
        Patch.new(@patches[index_for(xpos + dx, ypos + dy)].head, [])
      end
    end

    def index_for(x,y)
      ((y % @size) * @size) + (x % @size)
    end
  end
end
