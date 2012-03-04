FactoryGirl.define do
  factory :store do
    name "CMU"
    street "5001 Forbes Avenue"
    city "Pittsburgh"
    state "PA"
    zip "15213"
    phone { rand(10 ** 10).to_s.rjust(10,'0') }
    active true
    created_at Time.now
  end
  
  factory :employee do
    first_name "Austin"
    last_name "Smith"
    ssn { rand(9 ** 9).to_s.rjust(9,'0') }
    date_of_birth 19.years.ago.to_date
    phone { rand(10 ** 10).to_s.rjust(10,'0') }
    role "employee"
    active true
  end
  
  factory :assignment do
    association :store
    association :employee
    start_date 1.year.ago.to_date
    end_date 1.month.ago.to_date
    pay_level 1
  end
end