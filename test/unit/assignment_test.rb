require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  # Relationship macros ... 
  should belong_to(:store)
  should belong_to(:employee)
  
  # Validation macros ...     
  should validate_presence_of(:store_id)
  should validate_presence_of(:employee_id)
  should validate_numericality_of(:store_id)
  should validate_numericality_of(:employee_id)
  
  # Validating pay_level ...
  should allow_value(1).for(:pay_level)
  should allow_value(4).for(:pay_level)
  should validate_numericality_of(:pay_level)
  
  should_not allow_value(7).for(:pay_level)
  should_not allow_value(0).for(:pay_level)
  should_not allow_value(-2).for(:pay_level)
  should_not allow_value(0.44).for(:pay_level)
  should_not allow_value("af378").for(:pay_level)

  context "Assignments" do
    setup do
      @aud = FactoryGirl.create(:employee, :first_name => "Audrey", :phone => "412-268-8211", :role => "admin")
      @aus = FactoryGirl.create(:employee, :role => "manager", :date_of_birth => Date.new(1995,04,14))
      @cry = FactoryGirl.create(:employee, :first_name => "Crystal", :last_name => "Shine", :active => true)
      @bre = FactoryGirl.create(:employee, :first_name => "Brenda", :last_name => "Reyes", :active => true)
            

      # @sqh = Factory.create(:store, :name => "Squirrel Hill", :phone => "412-268-8211")
      @cmu = FactoryGirl.create(:store)
      @mar = FactoryGirl.create(:store, :name => "Market District")
      
      
    end
    
    teardown do
      @aud.destroy
      @aus.destroy
      @cry.destroy
      @bre.destroy
      @cmu.destroy
      @mar.destroy
    end

    should "not allow end date in future or before start date" do 
      @john = FactoryGirl.create(:employee, :first_name => "John", :role => "employee", :active => false, :date_of_birth => Date.new(1994,02,14))
      @sqh = FactoryGirl.create(:store, :name => "Squirrel Hill", :phone => "412-268-8211")
      
      assn_001 = FactoryGirl.build(:assignment, :store => @sqh, :employee => @john, :start_date => 7.months.ago.to_date, :end_date => 5.months.ago.to_date, :pay_level => 1)
      assert assn_001.valid?
      
      assn_002 = FactoryGirl.build(:assignment, :store => @sqh, :employee => @john, :start_date => 7.months.ago.to_date, :end_date => 10.days.from_now.to_date, :pay_level => 1)
      deny assn_002.valid?
      
      assn_003 = FactoryGirl.build(:assignment, :store => @sqh, :employee => @john, :start_date => 7.months.ago.to_date, :end_date => 9.months.ago.to_date, :pay_level => 1)
      deny assn_003.valid?  
      
      @john.destroy
      @sqh.destroy     
     end
     
     should " allow an assignment to have active store or employee" do
        # valid 
        @john = FactoryGirl.create(:employee, :first_name => "John", :role => "employee", :active => true, :date_of_birth => Date.new(1994,02,14))
        @sqh = FactoryGirl.create(:store, :name => "Squirrel Hill", :phone => "412-268-8211")
        @joe = FactoryGirl.create(:employee, :first_name => "Joe", :role => "employee", :active => true, :date_of_birth => Date.new(1994,02,14))
        
        assn_001 = FactoryGirl.build(:assignment, :store => @sqh, :employee => @john, :start_date => 7.months.ago.to_date, :end_date => 5.months.ago.to_date, :pay_level => 1)
        assert assn_001.valid?
        assert assn_001.save == true
      
        @john.destroy
        @sqh.destroy
        @joe.destroy
      end
  
      should "not allow an assignment to have an inactive store or employee" do
         # valid 
         @bill = FactoryGirl.create(:employee, :first_name => "Bill", :role => "employee", :active => true, :date_of_birth => Date.new(1994,02,14))
         @thor = FactoryGirl.create(:store, :name => "Thor", :phone => "412-268-8211")
         @bob = FactoryGirl.create(:employee, :first_name => "Bob", :role => "employee", :active => true, :date_of_birth => Date.new(1994,02,14))
      
         #invalid
         @mis = FactoryGirl.create(:employee, :first_name => "Missy", :last_name => "Gates", :active => false)
         @chat = Factory.create(:store, :name => "Chattum", :active => false)
      
         assn_001 = FactoryGirl.build(:assignment, :store => @chat, :employee => @bill, :start_date => 7.months.ago.to_date, :end_date => nil, :pay_level => 1)
         assert assn_001.save == false
         
         assn_002 = FactoryGirl.build(:assignment, :store => @thor, :employee => @mis, :start_date => 7.months.ago.to_date, :end_date => nil, :pay_level => 1)
         assert assn_001.save == false
         
         @bill.destroy
         @thor.destroy
         @bob.destroy
         @mis.destroy
         @chat.destroy
       end
       
       
       should "should make sure that the previous assignment ends when new one starts" do
         # active employees 
         @bill = FactoryGirl.create(:employee, :first_name => "Bill", :role => "employee", :active => true, :date_of_birth => Date.new(1994,02,14))
         @bar = FactoryGirl.create(:employee, :first_name => "Barbara", :role => "employee", :active => true, :date_of_birth => Date.new(1994,02,14))
      
         # active stores
         @st0 = FactoryGirl.create(:store, :name => "Thor", :phone => "412-268-8211")
         @st1 = Factory.create(:store, :name => "Chattum", :active => false)

         @assn_001 = FactoryGirl.create(:assignment, :store => @st0, :employee => @bill, :start_date => 7.months.ago.to_date, :end_date => nil, :pay_level => 1)
         assert_equal nil, @assn_001.end_date
         
         # @assn_002 = FactoryGirl.build(:assignment, :store => @st1, :employee => @bill, :start_date => 4.months.ago.to_date, :end_date => nil, :pay_level => 2)
         # assert_equal @assn_001.end_date, @assn_002.start_date
         # puts @assn_001.end_date.inspect 
         # puts @assn_002.start_date.inspect 
         
         # assert assn_001.save == false
         
         # @bill.destroy
         # @thor.destroy
         # @bob.destroy
         # @chat.destroy     
       end
       
       
        should "show current assignment" do
          @assn_001 = FactoryGirl.create(:assignment, :store => @cmu, :employee => @aud, :start_date => 4.months.ago.to_date, :end_date => nil, :pay_level => 2)
          assert_equal ["Smith, Audrey"], Assignment.current.map{|a| a.employee.name}
        end
       
       should "should show all assignments for a certain store" do
         @assn_001 = FactoryGirl.create(:assignment, :store => @cmu, :employee => @aud, :start_date => 4.months.ago.to_date, :end_date => nil, :pay_level => 2)
         @assn_002 = FactoryGirl.create(:assignment, :store => @cmu, :employee => @aus, :start_date => 4.months.ago.to_date, :end_date => nil, :pay_level => 2)
         assert_equal [@assn_001,@assn_002], Assignment.for_store(@cmu)
       end
       
       should "should show all assignments for a certain employee" do
         @assn_001 = FactoryGirl.create(:assignment, :store => @cmu, :employee => @aud, :start_date => 4.months.ago.to_date, :end_date => 3.months.ago.to_date, :pay_level => 2)
         @assn_002 = FactoryGirl.create(:assignment, :store => @cmu, :employee => @aud, :start_date => 3.months.ago.to_date, :end_date => nil, :pay_level => 2)  
         assert_equal [@assn_001,@assn_002], Assignment.for_employee(@aud)
       end
       
       should "should show all assignments for a certain pay level" do
         @assn_001 = FactoryGirl.create(:assignment, :store => @cmu, :employee => @aud, :start_date => 4.months.ago.to_date, :end_date => 3.months.ago.to_date, :pay_level => 2)
         @assn_002 = FactoryGirl.create(:assignment, :store => @cmu, :employee => @aud, :start_date => 3.months.ago.to_date, :end_date => nil, :pay_level => 2)  
         assert_equal [@assn_001,@assn_002], Assignment.for_pay_level(2)
       end
       
       should "should order all assignments by pay level" do
         @assn_001 = FactoryGirl.create(:assignment, :store => @cmu, :employee => @aud, :start_date => 4.months.ago.to_date, :end_date => 3.months.ago.to_date, :pay_level => 3)
         @assn_002 = FactoryGirl.create(:assignment, :store => @cmu, :employee => @aus, :start_date => 3.months.ago.to_date, :end_date => nil, :pay_level => 2)  
         @assn_003 = FactoryGirl.create(:assignment, :store => @cmu, :employee => @cry, :start_date => 4.months.ago.to_date, :end_date => 3.months.ago.to_date, :pay_level => 4)
         @assn_004 = FactoryGirl.create(:assignment, :store => @cmu, :employee => @bre, :start_date => 3.months.ago.to_date, :end_date => nil, :pay_level => 1)           
         assert_equal [@assn_004,@assn_002,@assn_001,@assn_003], Assignment.by_pay_level
       end
       
       should "should order all assignments by store" do
         @assn_001 = FactoryGirl.create(:assignment, :store => @cmu, :employee => @aud, :start_date => 4.months.ago.to_date, :end_date => 3.months.ago.to_date, :pay_level => 3)
         @assn_002 = FactoryGirl.create(:assignment, :store => @mar, :employee => @aus, :start_date => 3.months.ago.to_date, :end_date => nil, :pay_level => 2)  
         @assn_003 = FactoryGirl.create(:assignment, :store => @cmu, :employee => @cry, :start_date => 4.months.ago.to_date, :end_date => 3.months.ago.to_date, :pay_level => 4)
         assert_equal [@assn_001,@assn_003,@assn_002], Assignment.by_store
       end
       
       should "show that employee and store are not active" do
         #invalid
         @pyt = FactoryGirl.create(:employee, :first_name => "Prettyyoung", :last_name => "Thang", :active => false)
         @mic = Factory.create(:store, :name => "Michael Jackson", :active => false)
         assn_007 = FactoryGirl.build(:assignment, :store => @mic, :employee => @pyt, :start_date => 4.months.ago.to_date, :end_date => 3.months.ago.to_date, :pay_level => 3)
         assert_equal false, assn_007.employee_active?
         assert_equal false, assn_007.store_active?
         
         assn_008 = FactoryGirl.build(:assignment, :store => @mic, :employee => @yoo, :start_date => 4.months.ago.to_date, :end_date => 3.months.ago.to_date, :pay_level => 3)
         assert_equal false, assn_007.employee_active?
         deny assn_008.valid?
       end

       should "show that supdate prev" do
         #invalid
         @pyt = FactoryGirl.create(:employee, :first_name => "Prettyyoung", :last_name => "Thang", :active => false)
         @mic = Factory.create(:store, :name => "Michael Jackson", :active => false)
         @assn_009 = FactoryGirl.create(:assignment, :store => @mic, :employee => @pyt, :start_date => 4.months.ago.to_date, :end_date => 3.months.ago.to_date, :pay_level => 3)
         
         
         # assn_008 = FactoryGirl.build(:assignment, :store => @mic, :employee => @yoo, :start_date => 4.months.ago.to_date, :end_date => 3.months.ago.to_date, :pay_level => 3)
         #       assert_equal false, assn_007.employee_active?
         #       deny assn_008.valid?
       end  
       
  end #test
  
end
