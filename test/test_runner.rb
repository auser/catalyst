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
    
  end
  
end