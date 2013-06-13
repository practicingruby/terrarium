require_relative "buffered_hash"
require_relative "patch"
require_relative "creature"

module Terrarium
  class World
    def initialize(size)
      @size = size
      @patches = (@size**2).times.map do |i| 
                BufferedHash.new(:xpos  => i % @size,
                                 :ypos  => i / @size,
                                 :color => :black)
              end
      
      @creatures = []
    end

    attr_reader :patches, :creatures, :size


    def add_creature(x, y)
      @creatures << BufferedHash.new(:xpos    => x,
                                     :ypos    => y,
                                     :heading => 0,
                                     :color   => :red) 
    end

    def kill_creature(creature)
      @creatures.delete(creature)
    end

    def update_patch(x, y)
      patch = @patches[index_for(x, y)]

      yield Patch.new(patch, neighbors_for(patch), self)
      patch.commit
    end

    def each_patch
      @patches.each { |e| yield(Patch.new(e, neighbors_for(e), self)) } 

      @patches.each { |e| e.commit }
    end

    def each_creature
      @creatures.dup.each { |e| yield Creature.new(e, self) } # this shallow copy is intentional!

      @creatures.each { |e| e.commit }
    end

    def neighbors_for(e)
      xpos = e[:xpos]
      ypos = e[:ypos]


      offsets = [[0,1],[1,0],[0,-1],[-1,0],
                 [1,1],[-1,-1],[-1,1],[1,-1]]
      
      offsets.map do |dx, dy|
        Patch.new(@patches[index_for(xpos + dx, ypos + dy)].head, [], self)
      end
    end

    def index_for(x,y)
      ((y % @size) * @size) + (x % @size)
    end
  end
end
