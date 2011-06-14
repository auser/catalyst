module Catalyst  
  class Environment
    
    attr_reader :hash
    
    def initialize(hsh={})
      @hash = hsh
    end
    
    def []=(k,v)
      @hash[k] = v
    end
    
  end
end