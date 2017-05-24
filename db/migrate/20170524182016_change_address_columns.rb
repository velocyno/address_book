class ChangeAddressColumns < ActiveRecord::Migration[5.0]
  def change
    rename_column :addresses, :line_1, :street_address
    rename_column :addresses, :line_2, :secondary_address
  end
end
