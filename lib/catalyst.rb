module Catalyst
  class RunStack
    def initialize(&block)
      instance_eval(&block) if block_given?
    end
    
    # middleware stack
    def run_stack
      @_run_stack ||= []
    end
    
    # Use 'middleware'
    def use(k, *args, &block)
      if k.is_a?(RunStack)
        run_stack.concat(k.stack)
      else
        run_stack << [k, *args, block]
      end
      self
    end
    
    # run is just another term for 'use'
    def run
      @run = app
    end
    
    # Turn this RunStack to a Runner
    def to_app
      Runner.new(run_stack.dup)
    end
    
    # Start off the middleware
    def call(env)
      to_app.call(env)
    end
    
  end
end