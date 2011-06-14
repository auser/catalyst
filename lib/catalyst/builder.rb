module Catalyst
  
  class Builder
    
    # Builder
    def initialize(&block)
      instance_eval(&block) if block_given?
    end
        
    def use(middleware, *args, &block)
      if middleware.kind_of?(Builder)
        # Merge in the other builder's stack into our own
        self.stack.concat(middleware.stack)
      else
        self.stack << [middleware, args, block]
      end
      self
    end
    
    def run(app)
      @run = app
    end
    
    def stack
      @stack ||= []
    end
    
    def to_app(env={})
      Runner.new(stack.dup, env)
    end
    
    def call(env)
      p [:call, env]
      to_app(env).call(env)
    end
    
  end
  
end