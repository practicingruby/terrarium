require_relative "../lib/terrarium/scenario"

Terrarium::Scenario.define do
  patches { set_color [:black, :black, :white].sample }

  patches! do
    case neighbors.count { |e| e.color == :white }
    when 0..1, 4..8
      set_color :black unless color == :black
    when 3
      set_color :white unless color == :white
    end
  end
end
