module Microworlds
  class BufferedHash
    def initialize(head={})
      @head   = head
      @buffer = {}
    end

    attr_reader :head

    def [](key)
      @buffer[key] || @head[key]    
    end

    def []=(key, value)
      @buffer[key] = value
    end

    def changed?
      not @buffer.empty?
    end

    def commit
      return unless changed?

      @head.update(@buffer)
      @buffer.clear
    end

    def rollback
      return unless changed?

      @buffer.clear
    end
  end
end
