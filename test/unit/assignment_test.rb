require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  # Relationship macros ... #
  should belong_to(:store)
  should belong_to(:employee)
  
  # Validations ...         #
  #should validate_presence_of(:store_id)
  #should validate_presence_of(:employee_id)
  should validate_presence_of(:start_date)
  
end
