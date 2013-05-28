require_relative "../lib/microworlds"

sim     = Microworlds::Simulator.new
display = Microworlds::Visualization.new

sim.notify(display)

sim.up { set_patch_color [:black, :black, :white].sample }

sim.up! do
  case neighbors.count { |e| e.color == :white }
  when 0..1, 4..8
    set_patch_color :black unless color == :black
  when 3
    set_patch_color :white unless color == :white
  end
end

