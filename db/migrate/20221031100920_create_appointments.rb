class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.belongs_to :employee
      t.string :created_by
      t.string :type, null: false
      t.string :customer_email
      t.string :customer_type
      t.datetime :start_time
      t.datetime :end_time
      t.string :crm_id

      t.timestamps
    end
  end
end
