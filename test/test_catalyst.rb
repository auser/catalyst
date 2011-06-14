require 'helper'

class TestCatalyst < Test::Unit::TestCase
  class TestCatalystMiddleware
    def initialize(app)
      @app = app
    end
    def call(env)
      p [:called, TestCatalystMiddleware, env]
    end
  end
  
  context "Catalyst" do
    
    should "be able to build a run_stack" do
      assert_nothing_raised do
        Catalyst::RunStack.new do |env|
        end
      end
    end
    
    should "be able to define a run_stack" do
      assert_nothing_raised do
        Catalyst::RunStack.new do |env|
          use TestCatalystMiddleware
        end
      end
    end
    
  end
end
