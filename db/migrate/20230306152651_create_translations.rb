class CreateTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :translations do |t|
      t.string :translation_type
      t.string :name
      t.string :translated_as

      t.timestamps
    end
  end
end
