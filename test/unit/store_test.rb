require 'test_helper'

class StoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  # Relationship macros...
  should have_many(:assignments)
  should have_many(:employees).through(:assignments)
  
  # Validation macros ...
  should validate_presence_of(:name)
  should validate_presence_of(:street)
  
  # --> Validating zip
  should allow_value("03431").for(:zip)
  should allow_value("15217").for(:zip)
  should allow_value("15090").for(:zip)
  
  should_not allow_value("fred").for(:zip)
  should_not allow_value("3431").for(:zip)
  should_not allow_value("15213-9843").for(:zip)
  should_not allow_value("15d32").for(:zip)
  
  # --> Validating phone...
  should allow_value("4122683259").for(:phone)
  should allow_value("412-268-3259").for(:phone)
  should allow_value("412.268.3259").for(:phone)
  should allow_value("(412) 268-3259").for(:phone)
  
  should_not allow_value("2683259").for(:phone)
  should_not allow_value("4122683259x224").for(:phone)
  should_not allow_value("800-EAT-FOOD").for(:phone)
  should_not allow_value("412/268/3259").for(:phone)
  should_not allow_value("412-2683-259").for(:phone)
  
  # Validating state...
  should allow_value("PA").for(:state)
  should allow_value("WV").for(:state)
  should allow_value("OH").for(:state)
  should_not allow_value("bad").for(:state)
  should_not allow_value(10).for(:state)
  should_not allow_value("CA").for(:state)
 

  # -------------------------------------
  # Testing other methods with a context
  context "Creating three stores" do
    setup do 
      @pitt = Factory.create(:store, :name => "Pitt", :active => false)
      @sqh = Factory.create(:store, :name => "Squirrel Hill", :phone => "412-268-8211")
      @cmu = Factory.create(:store)
    end
    
    # provide a teardown method as well
          teardown do
            @pitt.destroy
            @sqh.destroy
            @cmu.destroy
          end
        
          # now run the tests:
          # test one of each factory (not really required, but not a bad idea)
          should "show that all factories are properly created" do
            assert_equal "CMU", @cmu.name
            assert_equal "Pitt", @pitt.name
            assert_equal "Squirrel Hill", @sqh.name
            assert @cmu.active
            assert @sqh.active
            deny @pitt.active ## deny is specified in test/test_helper.rb
          end
          
          
    # test the scope 'alphabetical'
    should "shows that there are three Stores in in alphabetical order" do
      assert_equal ["CMU", "Pitt", "Squirrel Hill"], Store.alphabetical.map{|s| s.name}
    end
    
    # test the scope 'active'
    should "shows that there are two active Stores" do
      assert_equal 2, Store.active.size
      assert_equal ["CMU", "Squirrel Hill"], Store.active.alphabetical. map{|s| s.name}
    end
    
    # test the scope 'search'
    should "shows that search for Store by name" do
      assert_equal 1, Store.search("Sq").size
      assert_equal 1, Store.search("C").size
    end
    
    # test the callback is working 'reformat_phone'
    should "shows that the Squirrel Hill Store's phone is stripped of non-digits" do
      assert_equal "4122688211", @sqh.phone
    end
    
    
  end #test begin   
end #store test
