require_relative "helpers"

module Terrarium
  class Patch
    include Helpers

    def initialize(data, neighbors, world)
      @data       = data
      @neighbors  = neighbors
      @world      = world
    end

    attr_reader :data, :neighbors
    
    def color
      data[:color]
    end
    
    def xpos
      data[:xpos]
    end

    def ypos
      data[:ypos]
    end

    def set_color(color)
      data[:color] = color
    end

    def hatch
      @world.add_creature(xpos, ypos)
    end
  end
end
