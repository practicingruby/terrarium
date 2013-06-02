require_relative "../lib/terrarium/scenario"

Terrarium::Scenario.define do
  # initial cabbage density
  patches { set_color(:green) if rand(1..10) < 5 }

  # cabbage regrowth rate
  patches! { set_color(:green) if rand(1..50) == 1 }

  # initial creature population
  create_creatures(200)

  # initial creature state
  creatures do 
    lt rand(0..359)
    fd rand(5..25)

    data[:energy] = 8

    set_color :magenta
  end

  # movement
  creatures! { rt(rand(1...40)); lt(rand(1..40)); fd(1) }

  # hunger
  creatures! { data[:energy] -= 1 }

  # death
  creatures! { destroy if data[:energy] < 1 }

  # cloning
  creatures! do 
    if data[:energy] > 10
      data[:energy] *= 0.25

      create_clone
    end
  end

  # eating
  creatures! do 
    update_patch do |patch| 
      if patch.color == :green
        patch.set_color :black 
        data[:energy] += 5
      end
    end
  end
end
