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
  #should validate_presence_of(:start_date)
  #should validate_presence_of(:pay_level)
  
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
      

      # @cmu = Factory.create(:store, :street => "3414 Forbes Avenue", :active => true)
      # @forbes = Factory.create(:store, :street => "3424 Forbes Street", :name => "Forbes Store")
      # @oakland = Factory.create(:store, :street => "3444 Forbes Road", :name => "Oakland Store")
      
      #@assn_001 = Factory.create(:assignment, :store => @sqh, :employee => @john, :start_date => 7.years.ago.to_date, :end_date => 4.days.ago.to_date, :pay_level => 1)
      #       @assn_002 = Factory.create(:assignment, :store => @cmu, :employee => @jus, :start_date => 1.day.ago.to_date, :end_date => nil, :pay_level => 3)
      #       @assn_003 = Factory.create(:assignment, :store => @mar, :employee => @bre, :start_date => 2.years.ago.to_date, :end_date => nil, :pay_level => 3)
      #@assn_004 = Factory.create(:assignment, :store => @oakland, :employee => @kevin, :start_date => 3.years.ago.to_date, :end_date => nil, :pay_level => 6)
    end
    
    teardown do

      @cmu.destroy


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
     
     should "should not allow an assignment to have an inactive store or employee" do
        # valid 
        @john = FactoryGirl.create(:employee, :first_name => "John", :role => "employee", :active => false, :date_of_birth => Date.new(1994,02,14))
        @sqh = FactoryGirl.create(:store, :name => "Squirrel Hill", :phone => "412-268-8211")

        #invalid
        @jus = FactoryGirl.create(:employee, :first_name => "Justin", :last_name => "Gates", :active => true)
        @pitt = Factory.create(:store, :name => "Pitt", :active => false)
        
        assn_001 = FactoryGirl.build(:assignment, :store => @sqh, :employee => @john, :start_date => 7.months.ago.to_date, :end_date => 5.months.ago.to_date, :pay_level => 1)
        deny assn_001.valid?

        assn_002 = FactoryGirl.build(:assignment, :store => @sqh, :employee => @john, :start_date => 7.months.ago.to_date, :end_date => 5.months.ago.to_date, :pay_level => 1)
        deny assn_002.valid?

        assn_003 = FactoryGirl.build(:assignment, :store => @sqh, :employee => @john, :start_date => 7.months.ago.to_date, :end_date => 9.months.ago.to_date, :pay_level => 1)
        deny assn_003.valid?
       
        deny @assignC.valid?
        deny @assignD.valid?
      
        @adam.destroy
        @barry.destroy
        @uci.destroy
        @ucsd.destroy
      
      end
      
       # 
       # should "should make sure that the previous assignment ends when new one starts" do
       #   @adam = Factory.create(:employee, :first_name => "Adam", :last_name => "Aardvork", :active => true)
       #   @uci = Factory.create(:store, :street => "3414 Forbes Avenue", :name => "UCI Store", :active => true)
       #   @ucsd = Factory.create(:store, :street => "3413 Forbes Avenue", :name => "UCSD Store", :active => true)
       #   
       #   @assignE = Factory.create(:assignment, :store => @ucsd, :employee => @adam, :start_date => 10.years.ago.to_date, :end_date => nil)
       #   @assignF = Factory.create(:assignment, :store => @uci, :employee => @adam, :start_date => 2.years.ago.to_date, :end_date => nil)
       #   
       #   assert_equal @assignF, @adam.current_assignment
       #   
       #   @adam.destroy
       #   @assignF.destroy
       #   @assignE.destroy
       #   @ucsd.destroy
       #   
       #   
       # end
       # 
       # should "show current assignment" do
       #   assert_equal ["Aardvork, Shrenik","Shah, Shreepal","Jacobs, Kevin"], Assignment.current.map{|a| a.employee.name}
       # end
       # 
       # should "should show all assignments for a certain store" do
       #   assert_equal [@assign1,@assign2], Assignment.for_store(@cmu)
       # end
       # 
       # should "should show all assignments for a certain employee" do
       #   assert_equal [@assign1,@assign2], Assignment.for_employee(@shrenik)
       # end
       # 
       # should "should show all assignments for a certain pay level" do
       #   #assert_equal [@assign2,@assign3], Assignment.for_pay_level(3)
       # end
       # 
       # should "should order all assignments by pay level" do
       #   assert_equal [@assign1,@assign2,@assign3,@assign4], Assignment.by_pay_level
       # end
       # 
       # should "should order all assignments by store" do
       #   assert_equal [@assign1,@assign2,@assign3,@assign4], Assignment.by_store
       # end
       # 
  end #test
  
end
