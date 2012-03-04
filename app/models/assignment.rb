class Assignment < ActiveRecord::Base
  # Callbacks
  # --------------------
  # ends previous assignment before adding a new one
  before_save :store_active?
  before_save :employee_active?
  before_create :end_previous_assignment
  
  # Relationships
  # -----------------------------
  belongs_to :store
  belongs_to :employee
  
  # Scopes
  # -----------------------------
  # returns all the current assignments
  scope :current, where("end_date IS NULL")
  # return all assignments associated with a given store
  scope :for_store, lambda { |store| where("store_id = ?", store)}
  # return all assignments associated with a given employee
  scope :for_employee, lambda { |emp| where("employee_id = ?", emp)}
  # return all assignments associated with a given pay_level
  scope :for_pay_level, lambda { |pay| where("pay_level = ?", pay)}
  # orders values by pay_level
  scope :by_pay_level, order('pay_level')
  # orders values by store
  scope :by_store, order('store_id')
  
  # Validations
  # -----------------------------
  # make sure required fields are present
  validates_presence_of :store_id, :employee_id, :start_date, :pay_level
  # make sure that the pay level is an *integer* between 1 and 6 inclusive
  validates_numericality_of :pay_level, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 6, :only_integer => true
  # makes sure that store_id is a number
  validates_numericality_of :store_id, :only_integer => true, :greater_than_or_equal_to => 0
  # makes sure that employee_id is a number
  validates_numericality_of :employee_id, :only_integer => true, :greater_than_or_equal_to => 0
  # checks associations
  validates_associated :store, :employee
  # checks end and start date
  validates_date :end_date, :after => :start_date, :on_or_before => Time.now.to_date, 
                 :allow_blank => true, :message => "end date must be after start date", :allow_nil => true
  
  # Methods
  # -----------------------------
  def store_active?
    store = self.store_id
    # find the store associated with the assignment
    if Store.find_by_id(store) == nil
      # check validity of user input
      errors.add(:store, "is not existing store")
      return false
    elsif Store.find_by_id(store).active == true
      return true
    else
      errors.add(:store, "is not an active store")
      return false
    end
  end
  
  def employee_active?
    employee = self.employee_id
    # find the employee associated with the assignment
    if Employee.find_by_id(employee) == nil
      # check validity of user input
      errors.add(:employee, "is not existing employee")
      return false
    elsif Employee.find_by_id(employee).active == true
      return true
    else
      errors.add(:employee, "is not an active employee")
      return false
    end
  end
  
  def end_previous_assignment
    # first check if there is an assignment before the one we are creating
    if Employee.find_by_id(self.employee_id).current_assignment != nil
      employee = self.employee_id
      new_assn_enddate = self.start_date
      # here we set the end_date to the current assignment to the start date of the new one
      curr_assn = Employee.find_by_id(employee).current_assignment
      if curr_assn.end_date == nil
        curr_assn.end_date = new_assn_enddate
        curr_assn.save!
      end
    end
  end
    
      
  
  
end
