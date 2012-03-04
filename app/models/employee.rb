class Employee < ActiveRecord::Base
  # Callbacks
  # -----------------------------
  before_save :reformat_phone
  before_save :validate_active_input

  
  
  # Relationships
  # -----------------------------
  has_many :assignments
  has_many :stores, :through => :assignments
  
  
  # Scopes
  # -----------------------------
  # list employees in alphabetical order
  scope :alphabetical, order('last_name, first_name')
  # get all the employees younger than 18
  scope :is_younger_than_18,  where('date_of_birth > ?', 18.years.ago.to_date) 
  # get all the employees younger than 18
  scope :is_18_or_older,  where('date_of_birth < ?', 18.years.ago.to_date)
  # get all the employees who are active 
  #scope :active, where('active = ? OR active = ? OR active = ? OR active = ?', true, 't', '1', 'true')
  scope :active, where('active = ?', 't')
  # get all the employees who are inactive 
  scope :inactive, where('active = ?', false)
  # gets the regular employees
  scope :regulars, where('role = ?', 'employee')
  # gets the managers
  scope :managers, where('role = ?', 'manager')
  # gets the regular employees
  scope :admins, where('role = ?', 'admin')
  
  # Validations
  # -----------------------------
  # make sure required fields are present
  validates_presence_of :first_name, :last_name, :date_of_birth, :role, :ssn
  # Make sure your employee was not born in the future
  validates_date :date_of_birth, :on_or_before => Time.now.to_date, :message => "birthday should be in the past"     #- test -#
  # Make sure your employee is not more than 100 years old
  validates_date :date_of_birth, :after => 100.years.ago.to_date, :message => "Are you sure this employee is over 100 years old?" #- test -#
  # Make sure your employee is not younger than 14 years old
  validates_date :date_of_birth, :on_or_before => 14.years.ago.to_date, :message => "Must be 14 years old to work in the state of PA"
  # Make sure ssn is valid   #- test -#
  validates_format_of :ssn, :with => /^\d{3}[- ]?\d{2}[- ]?\d{4}$/, :message => "should be nine digits long", :allow_blank => false
  # Makes sure names cannot have numbers    #- test -#
  validates_format_of :last_name, :with => /^[\w]+$/
  validates_format_of :first_name, :with => /^[\w]+$/
  # phone can have dashes, spaces, dots and parens, but must be 10 digits   #- test -#
  validates_format_of :phone, :with => /^(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})$/, :message => "should be 10 digits with area code"
  # makes sure that the employee has a valid role
  validates_inclusion_of :role, :in => %w[manager admin employee], :message => "is not an option", :allow_nil => true, :allow_blank => false 
  validates_uniqueness_of :ssn
  # searches for store by name
  scope :search, lambda { |term| where('first_name LIKE ? OR last_name LIKE ?', "#{term}%", "#{term}%") }
  #returns only inactive stores
  scope :inactive, where('active = ?', false)
  
  # Methods
  # -----------------------------
  def validate_active_input
  end
  
  def name
    last_name + ", " + first_name
  end
  
  def current_assignment
    empid = self.id
    curr = Assignment.start_date
  end
  
  def over_18?
    if (self.to_date < 18.years.ago.to_date)
      return true
    return false     
  end
  
  def age
    bday = self.date_of_birth
    currentYear = Time.now.year
    #yday tells you the number of days into the year the date is ex:Jun 28->180
    currDayOfYear = Time.now.yday
    bdayDayOfYear = self.date_of_birth.yday
    if(currDayOfYear < bdayDayOfYear)
      #the birthday hasnt passed so we need to subtract a year from the calculation
      return currentYear - bday.year - 1
    return currentYear - bday.year   
  end

  # Callback code
  # -----------------------------
   private
     # We need to strip non-digits before saving to db
     def reformat_phone
       phone = self.phone.to_s  # change to string in case input as all numbers 
       phone.gsub!(/[^0-9]/,"") # strip all non-digits
       self.phone = phone       # reset self.phone to new string
     end 
     
     #def reformat_birthday
     
     # def reformat_role
     #   r= self.role
     #   self.role = r.downcase!
     # end


end
