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
    
    should "not call the next app if @app.call is not invoked" do
      @@count = 0
      rs = Catalyst::RunStack.new do
        use lambda {|env, app| @@count += 1; app.call(env) }
        use lambda {|env, app| @@count += 1 }
        use lambda {|env, app| @@count += 1 }
        use lambda {|env, app| @@count += 1 }
      end
      
      rs.call({'i' => 0})
      assert_equal 2, @@count
    end
    
    should "be able to call a stack" do
      @@filtered_through_stack = false
      @rs = Catalyst::RunStack.new do
        use TestCatalystMiddleware
        use lambda {|env, app| @@filtered_through_stack = true }
      end
      
      @rs.call({})
      assert @@filtered_through_stack
    end
    
    should "be able to define a Catalyst run_Stack from the module" do
      @@count = 0
      rs = Catalyst.run_stack do
        use lambda {|env, app| @@count += 1; app.call}
        use lambda {|env, app| @@count += 1; app.call}
        use lambda {|env, app| @@count += 1; app.call}
      end
      rs.call()
      assert_equal @@count, 3
    end
  end
  
  should "be able to call run in place of use" do
    @@count = 0
    rs = Catalyst.run_stack do

      use lambda {|env, app| @@count += 1; app.call()}
      run lambda {|env, app| @@count += 1; app.call()}
    end
    
    rs.call
    assert_equal @@count, 2
  end
end
