require "pry"
require_relative "../lib/terrarium"

sim     = Terrarium::Simulator.new
display = Terrarium::Visualization.new

sim.notify(display)


sim.patches { set_patch_color(:green) if rand(1..10) < 5 }

grass = sim.patches! { set_patch_color(:green) if rand(1..50) == 1 }

sim.create_creatures(200)

sim.creatures do 
  lt rand(0..359)
  fd rand(5..25)

  data[:energy] = 8

  set_color :magenta
end

wiggle = sim.creatures! { rt(rand(1...40)); lt(rand(1..40)); fd(1) }

hunger = sim.creatures!(0.05) { data[:energy] -= 1 }
death  = sim.creatures!       { destroy if data[:energy] < 1 }

breed  = sim.creatures! do 
  if data[:energy] > 10
    data[:energy] *= 0.25

    create_clone
  end
end

eat    = sim.creatures! do 
           sim.world.update_patch(xpos.round, ypos.round) do |e| 
             if e.color == :green
               e.set_patch_color :black 
               data[:energy] += 5
             end
           end
         end

sim.pry
