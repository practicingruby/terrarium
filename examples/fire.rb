require_relative "../lib/terrarium/scenario"

Terrarium::Scenario.define do
  patches do
    with_probability(0.5) { set_color :green }
  end

  patches! do
    if color == :green && neighbors.any? { |e| e.color == :red }
      set_color :red
    end
  end

  random_patch { set_color :red }
end
