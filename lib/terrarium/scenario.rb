require_relative "simulator"
require_relative "visualization"

module Terrarium
  module Scenario
    def self.define(&block)
      sim      = Simulator.new
      display  = Visualization.new

      sim.notify(display)

      sim.patches { set_color :black }

      puts "Hit enter key to get started!"
      gets

      sim.instance_eval(&block)
    end
  end
end
