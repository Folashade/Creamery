class Employee < ActiveRecord::Base
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
  scope :active, where('active = ?', true)
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
  validates_date :date_of_birth, :on_or_before => :today
end
