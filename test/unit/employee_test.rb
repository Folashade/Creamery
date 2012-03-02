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
  
  #Validations
  #validates_presence_of :username
  # validates_uniqueness_of :username, :email, :allow_blank => true
  # validates_format_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  # validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  # validates_presence_of :password, :on => :create
  # validates_confirmation_of :password
  # validates_length_of :password, :minimum => 4, :allow_blank => true
end
