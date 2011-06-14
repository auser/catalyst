require 'helper'

class TestCatalyst < Test::Unit::TestCase
  class TestCatalystMiddleware
    def initialize(app)
      @app = app
    end
    
    def call(env)
      # p [:app, @app.stack]
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
      @rs = Catalyst::RunStack.new do
        use TestCatalystMiddleware
        use lambda {|env| p [:env, env]}
      end
      
      @rs.call({})
    end
    
  end
end
