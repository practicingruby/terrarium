require_relative "../lib/terrarium/scenario"

Terrarium::Scenario.define do
  create_creatures 10

  creatures! { set_color :white }
  creatures! { wiggle(0.5) }

  creatures! do
    with_probability(0.01) do
      with_probability(0.3) do
        update_patch { |patch| patch.set_color :yellow }
      end

      destroy
    end
  end

  patches! do
    next unless color == :yellow

    with_probability(0.01) do
      10.times { hatch }
    end
  end
end
