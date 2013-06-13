require_relative "helpers"

module Terrarium
  class Creature
    include Helpers

    def initialize(data, world)
      @data        = data
      @world       = world
    end

    attr_reader :data, :world

    def color
      data[:color]
    end

    def set_color(value)
      data[:color] = value
    end

    def xpos
      data[:xpos]
    end

    def ypos
      data[:ypos]
    end

    def heading
      data[:heading]
    end

    def nearby_creatures(distance=1)
      world.creatures
        .select { |e| distance_to(e[:xpos], e[:ypos]) < distance }
        .map { |e| self.class.new(e, world) }
    end

    def wiggle(movement_speed=0.1)
      lt rand(1..40)
      rt rand(1..40)

      fd movement_speed
    end

    def distance_to(x, y)
      Math.hypot(x - xpos, y - ypos)
    end

    def destroy
      world.kill_creature(@data)
    end

    def update_patch
      world.update_patch(data[:xpos].round, data[:ypos].round) { |patch| yield(patch) }
    end

    def hatch
      copied_creature = Marshal.load(Marshal.dump(data))

      world.creatures << copied_creature
    end

    def fd(amount)
      angle = data[:heading] * Math::PI / 180

      hx = (data[:xpos] + (amount * Math.cos(angle))) % @world.size
      hy = (data[:ypos] + (amount * Math.sin(angle))) % @world.size

      data[:xpos] = hx
      data[:ypos] = hy
    end

    def rt(degrees)
      data[:heading] = (data[:heading] + degrees) % 360
    end

    def lt(degrees)
      data[:heading] = (data[:heading] - degrees) % 360
    end
  end
end
