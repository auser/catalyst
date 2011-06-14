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
    def use(k, &block)
      if k.is_a?(RunStack)
        stack.concat(k.stack)
      else
        stack << concat_to_stack(k, &block)
      end
      self
    end
    
    def concat_to_stack(klass, &block)
      if klass.is_a?(Class)
        klass.new(self, &block)
      elsif klass.respond_to?(:call)
        lambda do |env|
          klass.call(env)
          self.call(env)
        end
      else
        raise
      end
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