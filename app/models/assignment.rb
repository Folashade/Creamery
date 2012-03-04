class Assignment < ActiveRecord::Base
  # Relationships
  # -----------------------------
  belongs_to :store
  belongs_to :employee
  
  # Validations
  # -----------------------------
  # make sure required fields are present
  validates_presence_of :store_id, :employee_id, :start_date, :pay_level
  # Make sure your assignment was not born in the future
  validates_date :start_date, :on_or_before => Time.now.to_date, :message => "birthday should be in the past"
end
