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
  scope :active, where('active = ? OR active = ? OR active = ? OR active = ?', true, 't', '1', 'true')
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
  validates_date :date_of_birth, :on_or_before => :today        #- test -#
  # Make sure your employee is not more than 100 years old
  validates_date :date_of_birth, :after => 100.years.ago.to_date  #- test -#
  # Make sure your employee is not younger than 14 years old
  validates_date :date_of_birth, :on_or_before => 14.years.ago.to_date
  # Make sure ssn is valid   #- test -#
  validates_format_of :ssn, :with => /^\d{3}[- ]?\d{2}[- ]?\d{4}$/, :message => "should be nine digits long", :allow_blank => false
  # Makes sure names cannot have numbers    #- test -#
  validates_format_of :last_name, :with => /^[\w]+$/
  validates_format_of :first_name, :with => /^[\w]+$/
  # phone can have dashes, spaces, dots and parens, but must be 10 digits   #- test -#
  validates_format_of :phone, :with => /^(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})$/, :message => "should be 10 digits (area code needed) and delimited with dashes only"
  # makes sure that the employee has a valid role
  validates_inclusion_of :role, :in => %w[manager admin employee], :message => "is not an option", :allow_nil => true, :allow_blank => false 


  # Methods
  # -----------------------------
  def validate_active_input
    if %w[t true 1].include?(self.active) == true
      self.active = 't'
      self.save!
    end
  end
  
  def name
    last_name + ", " + first_name
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


end
