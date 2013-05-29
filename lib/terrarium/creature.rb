module Terrarium
  class Creature
    def initialize(data, world_size)
      @data        = data
      @world_size  = world_size
    end

    def heading
      @data[:heading]
    end

    def xpos
      @data[:xpos]
    end

    def ypos
      @data[:ypos]
    end

    def color
      @data[:color]
    end

    def heading
      @data[:heading]
    end

    def fd(amount)
      angle = heading * Math::PI / 180

      hx = (@data[:xpos] + (amount * Math.cos(angle))) % @world_size
      hy = (@data[:ypos] + (amount * Math.sin(angle))) % @world_size

      @data[:xpos] = hx
      @data[:ypos] = hy
    end

    def rt(degrees)
      @data[:heading] = (@data[:heading] + degrees) % 360
    end

    def lt(degrees)
      @data[:heading] = (@data[:heading] - degrees) % 360
    end

    def set_color(color)
      @data[:color] = color
    end
  end
end
