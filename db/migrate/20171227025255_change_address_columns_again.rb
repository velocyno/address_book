class ChangeAddressColumnsAgain < ActiveRecord::Migration[5.0]
  def change
    rename_column :addresses, :street_address, :address1
    rename_column :addresses, :secondary_address, :address2
  end
end
