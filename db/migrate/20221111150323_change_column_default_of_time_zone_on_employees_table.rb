class ChangeColumnDefaultOfTimeZoneOnEmployeesTable < ActiveRecord::Migration[7.0]
  def change
    change_column_default :employees, :time_zone, from: 'UTC', to: 'London'
  end
end
