class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :line_1
      t.string :line_2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country
      t.date :birthday
      t.text :note

      t.timestamps
    end
  end
end
