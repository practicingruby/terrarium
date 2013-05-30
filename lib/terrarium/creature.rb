module Terrarium
  class Creature
    def initialize(data, world)
      @data        = data
      @world       = world
    end

    attr_reader :data

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

    def destroy
      @world.kill_creature(@data)
    end

    def patch_here
      @world.update_patch(xpos.round, ypos.round) { |patch| yield(patch) }
    end

    def create_clone
      copied_creature = Marshal.load(Marshal.dump(@data))

      @world.creatures << copied_creature
    end

    def fd(amount)
      angle = heading * Math::PI / 180

      hx = (@data[:xpos] + (amount * Math.cos(angle))) % @world.size
      hy = (@data[:ypos] + (amount * Math.sin(angle))) % @world.size

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
