require_relative "../lib/terrarium/scenario"

Terrarium::Scenario.define do
  create_creatures 100

  creatures do 
    set_color [:magenta, :cyan, :blue, :green, :yellow, :red].sample
    lt rand(0..359)
    fd rand(5..15)
  end

  creatures! do 
    rt rand(1...40)
    lt rand(1..40)
    fd 0.1 
  end

  creatures! do
    case rand(1..25)
    when 1
      destroy
    when 2
      hatch
    end
  end
end
