module Helpers
  def with_probability(num)
    yield if rand <= num
  end

  def coinflip
    [true, false].sample
  end
end
