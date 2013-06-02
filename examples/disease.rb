require_relative "../lib/terrarium/scenario"

Terrarium::Scenario.define do
  create_creatures 200

  creatures do 
    lt rand(0..359)
    fd rand(5..15)

    data[:sick_time] = 0

    with_probability(0.02) do
      set_color :yellow 
      
      data[:sick_time] = 10
    end
  end

  creatures! do
    lt rand(1..40)
    rt rand(1..40)

    fd 0.2
  end

  creatures! do
    next unless color == :red

    if nearby_creatures.any? { |e| e.color == :yellow}
      set_color :yellow
      
      data[:sick_time] = 10
    end
  end

  creatures!(1) do
    data[:sick_time] -= 1 if data[:sick_time] > 0

    if data[:sick_time].zero? && color != :red
      rand(1..2) == 1 ? set_color(:red) : destroy
    end
  end
end
