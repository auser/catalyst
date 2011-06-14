module Catalyst  
  class Environment
    
    def initialize(hsh={})
      @hash = hsh
    end
    
    def []=(k,v)
      @hash[k] = v
    end
    
  end
end