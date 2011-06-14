module Catalyst
  class Runner
    attr_reader :actions

    def initialize(actions)
      @actions = actions
    end
    
    def stack
      @stack ||= []
    end

    def call(env)
      return if @actions.empty?

      begin
        @stack.unshift(@actions.shift).first.call(env)
      rescue Exception => e
        env["catalyst.error"] = e
        raise
      end
    end
  end
  
end