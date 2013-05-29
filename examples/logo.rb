require "pry"
require_relative "../lib/terrarium"

sim     = Terrarium::Simulator.new
display = Terrarium::Visualization.new

sim.notify(display)

sim.create_creatures(10)

sim.pry
