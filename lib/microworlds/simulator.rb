require "thread"

module Microworlds
  class Simulator
    DIMENSIONS = 64

    def initialize
      @world     = World.new(DIMENSIONS)
      @listeners = []
      @lock      = Mutex.new
    end

    def notify(obj)
      @listeners << obj
    end

    attr_reader :world

    def update_patches(&block)
      @lock.synchronize do
        @world.each_patch { |patch| patch.instance_eval(&block) }

        @listeners.each { |e| e.update(self) }
      end

      nil
    end

    def up!(interval=0.025, &block)
      loop do
        sleep interval

        update_patches(&block)
      end
    end

    alias_method :up, :update_patches
  end
end
