module Catalyst
  class Runner
    attr_reader :actions, :history

    def initialize(actions)
      @history = []
      @actions = actions.map {|act| setup_action(act) }
    end
    
    def call(env)
      return if @actions.empty?

      begin
        action = @history.unshift(@actions.shift).first
        action.call(env)
      rescue Exception => e
        env["catalyst.error"] = e
        raise
      end
    end
    
    def setup_action(action)
      action
    end
  end
end