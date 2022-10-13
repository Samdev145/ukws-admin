class CreateEmployees < ActiveRecord::Migration[6.1]
  def change
    create_table :employees do |t|
      t.string :name, null: false
      t.string :calendar_id, null: false
      t.string :contact_number, null: false
      t.string :job, null: false
      t.text :introduction
      t.string :time_zone, default: "UTC"

      t.timestamps
    end
  end
end
