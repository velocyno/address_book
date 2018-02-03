class ChangeAddressInterestColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :interest_climb, :boolean
    add_column :addresses, :interest_dance, :boolean
    add_column :addresses, :interest_read, :boolean
  end
end
