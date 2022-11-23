# frozen_string_literal: true

class AddInternalToEmployees < ActiveRecord::Migration[7.0]
  def change
    add_column :employees, :internal, :boolean, default: false
  end
end
