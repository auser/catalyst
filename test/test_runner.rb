require 'helper'

class TestRunner < Test::Unit::TestCase
  
  context "Runner" do
    
    setup do
      @klass = Catalyst::Runner
      @instance = @klass.new([])
    end
    
    context "initializing" do
      should "setup the action" do
        middleware = [1,2,3]
        middleware.each do |m|
          @klass.any_instance.expects(:setup_action).with(m).returns(m)
        end
        @inst = @klass.new(middleware)
        assert_equal @inst.actions, [1,2,3]
        assert_empty @inst.history
      end
    end
    
    context "setting up middleware" do
      should "make non-classes lambdas" do
        env = new_environment
        env.expects(:foo).once

        func = lambda { |x| x.foo }
        @instance.setup_action(func).call(env)
      end
      
      should "raise exception if given invalid middleware" do
        assert_raises(RuntimeError) {
          @instance.setup_action(7)
        }
      end
    end
    
    context "calling" do
      should "return if there are no actions to run" do
        @instance.history.expects(:shift).never
        assert !@instance.call(new_environment)
      end
      
      should "move an action to the history stack" do
        @instance.actions << lambda { |env| }
        assert @instance.history.empty?
        @instance.call(new_environment)
        assert @instance.actions.empty?
        assert !@instance.history.empty?
      end
      
      should "call filtered actions" do
        
      end
    end
    
  end
  
end