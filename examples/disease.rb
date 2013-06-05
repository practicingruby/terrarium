require_relative "../lib/terrarium/scenario"

Terrarium::Scenario.define do
  healthy_color = :cyan
  sick_color    = :yellow

  initial_population = 200
  crowd_range        = 5..15
  sick_time          = 5
  infection_density  = 0.02
  movement_speed     = 0.5
  
  create_creatures(initial_population)
  
  # rule 1: arrange a group of healthy creatures into a crowd
  creatures do 
    lt rand(0..359)
    fd rand(crowd_range)

    data[:sick_time] = 0
    set_color healthy_color
  end

  # rule 2: infect some creatures
  creatures do
    with_probability(infection_density) do
      set_color sick_color
      
      data[:sick_time] = sick_time
    end
  end

  # rule 3: allow the creatures to move about randomly
  creatures! do
    lt rand(1..40)
    rt rand(1..40)

    fd movement_speed
  end

  # rule 4: spread disease on contact
  creatures! do
    next unless color == healthy_color

    if nearby_creatures.any? { |e| e.color == sick_color }
      set_color sick_color
      
      data[:sick_time] = sick_time
    end
  end

  # rule 5: recover or die based on probability 
  creatures!(1) do
    next unless color == sick_color

    if data[:sick_time] > 0
      data[:sick_time] -= 1 
    else
      coinflip ? set_color(healthy_color) : destroy
    end
  end
end
