class ChangeAddressAgeColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :addresses, :number, :age
  end
end
