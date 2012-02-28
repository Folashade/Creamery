class Assignment < ActiveRecord::Base
  # Relationships
  # -----------------------------
  belongs_to :store
  belongs_to :employee
  
  # Validations
  # -----------------------------
  # make sure required fields are present
  #validates_presence_of 
end
