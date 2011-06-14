require 'helper'

class TestCatalyst < Test::Unit::TestCase
  class TestCatalystMiddleware
    def initialize(app)
      @app = app
    end
    
    def call(env)
      @app.call(env)
    end
  end
  
  context "Catalyst" do
    
    should "be able to build a stack" do
      assert_nothing_raised do
        Catalyst::RunStack.new do |env|
        end
      end
    end
    
    should "be able to define a stack" do
      assert_nothing_raised do
        Catalyst::RunStack.new do |env|
          use TestCatalystMiddleware
        end
      end
    end
    
    should "be able to call a stack" do
      @@filtered_through_stack = false
      @rs = Catalyst::RunStack.new do
        use TestCatalystMiddleware
        use lambda {|env| @@filtered_through_stack = true }
      end
      
      @rs.call({})
      assert @@filtered_through_stack
    end
    
  end
end