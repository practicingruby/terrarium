module Terrarium
  class Patch
    def initialize(data, neighbors)
      @data       = data
      @neighbors  = neighbors
    end

    attr_reader :data, :neighbors

    def xpos
      @data[:xpos]
    end

    def ypos
      @data[:ypos]
    end

    def color
      @data[:color]
    end

    def set_patch_color(color)
      @data[:color] = color
    end
  end
end
