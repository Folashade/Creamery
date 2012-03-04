require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  #Relationship macros...
  should have_many(:assignments)
  should have_many(:stores).through(:assignments)
  
  # Validation macros ...
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)

  # Validating phone...
  should allow_value("4122683259").for(:phone)
  should allow_value("412-268-3259").for(:phone)
  should allow_value("412.268.3259").for(:phone)
  should allow_value("(412) 268-3259").for(:phone)
  
  should_not allow_value("2683259").for(:phone)
  should_not allow_value("4122683259x224").for(:phone)
  should_not allow_value("800-EAT-FOOD").for(:phone)
  should_not allow_value("412/268/3259").for(:phone)
  should_not allow_value("412-2683-259").for(:phone)
  
  # Validation ssn
  should allow_value("621923882").for(:ssn)
  should allow_value("621-92-3882").for(:ssn)
  
  should_not allow_value("2683259").for(:ssn)
  should_not allow_value("jhad39").for(:ssn)
  should_not allow_value("621923882783236").for(:ssn)
  
  # Validation date_of_birth
  should allow_value("1992-01-04").for(:date_of_birth)
  
  should_not allow_value("2013-01-04").for(:date_of_birth)
  should_not allow_value("01-04-2013").for(:date_of_birth)

  # Validation role 
  should allow_value("admin").for(:role)
  should allow_value("manager").for(:role)
  should allow_value("employee").for(:role)
  
  should_not allow_value("Admin").for(:role)
  should_not allow_value("Manager").for(:role)
  should_not allow_value("Employee").for(:role)
  
  # -------------------------------------
  # Testing other methods with a context
  context "Creating three employees" do
    setup do 
      @john = Factory.create(:employee, :first_name => "John", :role => "employee", :active => false)
      @aud = Factory.create(:employee, :first_name => "Audrey", :phone => "412-268-8211", :role => "admin")
      @aus = Factory.create(:employee, :role => "manager")
    end
    
    # provide a teardown method as well
          teardown do
            @john.destroy
            @aud.destroy
            @aus.destroy
          end
        
          # now run the tests:
          # test one of each factory (not really required, but not a bad idea)
          should "show that all factories are properly created" do
            assert_equal "John", @john.first_name
            assert_equal "Audrey", @aud.first_name
            assert_equal "Austin", @aus.first_name
            assert_equal "employee", @john.role
            assert_equal "admin", @aud.role
            assert_equal "manager", @aus.role
            assert @aus.active
            assert @aud.active
            deny @john.active ## deny is specified in test/test_helper.rb
          end
          
    # test the scope 'name'  
    should "show the name last, first" do
      assert_equal "Smith, John", @john.name
    end
          
    # test the scope 'alphabetical'
    should "show that there are three Employees in in alphabetical order" do
      assert_equal ["Smith, Audrey", "Smith, Austin", "Smith, John"], Employee.alphabetical.map{|e| e.name}
    end
    
    # test the scope 'active'
    should "show that there are two active Employees" do
      assert_equal 2, Employee.active.size
      assert_equal ["Smith, Audrey", "Smith, Austin"], Employee.active.alphabetical.map{|e| e.name}
    end
    
    # test the scope 'inactive'
    should "show that there are one inactive Employees" do
      assert_equal 1, Employee.inactive.size
      assert_equal ["Smith, John"], Employee.inactive.alphabetical.map{|e| e.name}
    end
    
    # test the scope 'search'
    should "show that search for Employee by first or last name" do
      assert_equal 2, Employee.search("Au").size
      assert_equal 1, Employee.search("J").size
    end
    
    # test the callback is working 'reformat_phone'
    should "show that the Squirrel Hill Store's phone is stripped of non-digits" do
      assert_equal "4122688211", @aud.phone
    end
    
    # test scope: is_younger_than_18
    should "show that all the employees are not younger than 18" do
      assert_equal [], Employee.is_younger_than_18
    end
    
    # test scope: is_18_or_older 
    should "shos that all the employees 18 or older" do
      assert_equal ["Smith, Audrey", "Smith, Austin", "Smith, John"], Employee.is_18_or_older.alphabetical.map{|e| e.name}
    end

    # test scope: admins     
    should "show that one of the employees is an Admin" do
      assert_equal ["Smith, Audrey"], Employee.admins.map{|e| e.name}
    end

    # test scope: managers      
    should "show that one of the employees is an Manager" do
      assert_equal ["Smith, Austin"], Employee.managers.map{|e| e.name}
    end

    # test scope: regulars      
    should "show that one of the employees is an Employee" do
      assert_equal ["Smith, John"], Employee.regulars.map{|e| e.name}
    end
    
    
  end #test begin
end
