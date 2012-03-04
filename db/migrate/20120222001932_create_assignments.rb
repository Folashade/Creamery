class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :store_id
      t.integer :employee_id
      t.datetime :start_date, :default => Time.now
      t.datetime :end_date
      t.integer :pay_level

      t.timestamps
    end
  end
end
