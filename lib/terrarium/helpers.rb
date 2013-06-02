module Helpers
  def with_probability(num)
    yield if rand <= num
  end
end
