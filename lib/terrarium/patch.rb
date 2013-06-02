require_relative "helpers"

module Terrarium
  class Patch
    include Helpers

    def initialize(data, neighbors)
      @data       = data
      @neighbors  = neighbors
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
  end
end
