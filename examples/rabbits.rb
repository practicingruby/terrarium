require_relative "../lib/terrarium/scenario"

Terrarium::Scenario.define do
  cabbage_density    = 0.5 
  regrowth_rate      = 0.02
  initial_population = 200
  initial_energy     = 8
  food_energy        = 5
  hatch_threshold    = 10
  hatched_energy     = 0.25

  cabbage_color = :green
  rabbit_color  = :white
  soil_color    = :black

  # initial cabbage density
  patches do 
    set_color soil_color
    with_probability(cabbage_density) { set_color(cabbage_color) } 
  end

  # cabbage regrowth rate
  patches! do
    with_probability(regrowth_rate) { set_color(cabbage_color) } 
  end

  # initial creature population
  create_creatures(200)

  # initial creature state
  creatures do 
    lt rand(0..359)
    fd rand(5..25)

    data[:energy] = initial_energy

    set_color rabbit_color
  end

  # movement
  creatures! { rt(rand(1...40)); lt(rand(1..40)); fd(1) }

  # hunger
  creatures! { data[:energy] -= 1 }

  # death
  creatures! { destroy if data[:energy] < 1 }

  # cloning
  creatures! do 
    if data[:energy] > hatch_threshold
      data[:energy] *= hatched_energy

      hatch
    end
  end

  # eating
  creatures! do 
    update_patch do |patch| 
      next unless patch.color == cabbage_color

      patch.set_color soil_color
      data[:energy] += food_energy
    end
  end
end


