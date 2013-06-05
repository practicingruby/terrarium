require "thread"

require_relative "world"

module Terrarium
  class Simulator
    DIMENSIONS = 75

    def initialize
      @world     = World.new(DIMENSIONS)
      @listeners = []
      @lock      = Mutex.new
    end

    def notify(obj)
      @listeners << obj
    end

    attr_reader :world

    def create_creatures(amount)
      @lock.synchronize do
        amount.times do 
          @world.add_creature(DIMENSIONS/2.0, DIMENSIONS/2.0)
        end

        @listeners.each { |e| e.update(self) }
      end
        
      nil
    end

    def creatures(&block)
      @lock.synchronize do
        @world.each_creature { |creature| creature.instance_eval(&block) }

        @listeners.each { |e| e.update(self) }
      end

      nil
    end

    def monitor(label)
      Thread.new do
        loop do
          sleep 1
          puts "#{label}: #{yield world}"
        end
      end
    end

    def creatures!(interval=0.025, &block)
      Thread.new do
        loop do
          sleep interval

          creatures(&block)
        end
      end
    end

    def random_patch(&block)
      patch(rand(0...@world.size), rand(0...@world.size), &block)
    end

    def patch(x, y, &block)
      @lock.synchronize do
        @world.update_patch(x,y) { |patch| patch.instance_eval(&block) }
      end
    end

    def patches(&block)
      @lock.synchronize do
        @world.each_patch { |patch| patch.instance_eval(&block) }

        @listeners.each { |e| e.update(self) }
      end

      nil
    end

    def patches!(interval=0.025, &block)
      Thread.new do
        loop do
          sleep interval

          patches(&block)
        end
      end
    end
  end
end
