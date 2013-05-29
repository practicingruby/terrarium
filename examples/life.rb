require "pry"
require_relative "../lib/terrarium"

sim     = Terrarium::Simulator.new
display = Terrarium::Visualization.new

sim.notify(display)

sim.patches { set_patch_color [:black, :black, :white].sample }

Thread.new do
  sim.patches! do
    case neighbors.count { |e| e.color == :white }
    when 0..1, 4..8
      set_patch_color :black unless color == :black
    when 3
      set_patch_color :white unless color == :white
    end
  end
end

binding.pry
