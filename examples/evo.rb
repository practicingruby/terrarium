require "pry"
require_relative "../lib/terrarium"

sim     = Terrarium::Simulator.new
display = Terrarium::Visualization.new

sim.notify(display)

sim.create_creatures(100)

sim.creatures do 
  set_color [:magenta, :cyan, :blue, :green, :yellow, :red, :orange].sample
  lt rand(0..359)
  fd rand(5..15)
end

wiggle = sim.creatures! { rt(rand(1...40)); lt(rand(1..40)); fd(0.1) }

evolve = sim.creatures!(0.01) do
           case rand(1..100)
           when 1
             destroy
           when 2
             create_clone
           end
         end

#sim.pry
