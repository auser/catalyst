$:.unshift(File.dirname(__FILE__))

module Catalyst
  autoload :Runner, 'catalyst/runner'
  autoload :Environment, 'catalyst/environment'
  
  class RunStack
    
    def initialize(&block)
      instance_eval(&block) if block_given?
    end
    
    # middleware stack
    def stack
      @stack ||= []
    end
    
    # Use 'middleware'
    def use(k, *args, &block)
      if k.is_a?(RunStack)
        stack.concat(k.stack)
      else
        stack << [k, *args, block]
      end
      self
    end
    
    # run is just another term for 'use'
    def run
      @run = app
    end
    
    # Turn this RunStack to a Runner
    def to_app
      Runner.new(stack)
    end
    
    # Start off the middleware
    def call(env)
      to_app.call(env.is_a?(Environment) ? env : Environment.new(env))
    end 
  end
end