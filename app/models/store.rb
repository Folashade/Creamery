class Store < ActiveRecord::Base
   before_save :reformat_phone
  
  # Relationships
  # -----------------------------
  has_many :employees, :through => :assignments
  has_many :assignments 
  
  # Scopes
  # -----------------------------
  # list stores in alphabetical order
  scope :alphabetical, order('name')
  #returns only inactive stores
  scope :inactive, where('active = ?', false)
  #returns only active stores
  scope :active, where('active = ?', true)
  # searches for store by name
  scope :search, lambda { |store| where('name LIKE ?', "#{store}%") }
  
  
  # Validations
  # -----------------------------
  # make sure required fields are present
  validates_presence_of :name, :street, :city, :state, :zip, :phone
  # if zip included, it must be 5 digits only
  validates_format_of :zip, :with => /^\d{5}$/, :message => "should be five digits long", :allow_blank => true
  # phone can have dashes, spaces, dots and parens, but must be 10 digits
  validates_format_of :phone, :with => /^(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})$/, :message => "should be 10 digits (area code needed) and delimited with dashes only"
  # if state is given, must be one of the choices given (no hacking this field)
  validates_inclusion_of :state, :in => %w[PA OH WV], :message => "is not an option", :allow_nil => true, :allow_blank => true
  # makes sure the stores names are unique within the system
  validates_uniqueness_of :name
  #/^[\w\d]+$/


  # Methods
  # -----------------------------


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

