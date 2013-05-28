module Microworlds
  class World
    def initialize(size)
      @size = size
      @data = (@size**2).times.map do |i| 
                BufferedHash.new(:xpos  => i % @size,
                                 :ypos  => i / @size,
                                 :color => :black)
              end
    end

    attr_reader :data

    def each
      @data.each { |e| yield(Patch.new(e, neighbors_for(e))) } 

      @data.each { |e| e.commit }
    end

    def neighbors_for(e)
      xpos = e[:xpos]
      ypos = e[:ypos]


      offsets = [[0,1],[1,0],[0,-1],[-1,0],
                 [1,1],[-1,-1],[-1,1],[1,-1]]
      
      offsets.map do |dx, dy|
        Patch.new(@data[index_for(xpos + dx, ypos + dy)].head, [])
      end
    end

    def index_for(x,y)
      ((y % @size) * @size) + (x % @size)
    end
  end
end
