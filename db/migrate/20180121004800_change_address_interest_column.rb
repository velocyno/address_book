class ChangeAddressInterestColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :interest_climb, :integer
    add_column :addresses, :interest_dance, :integer
    add_column :addresses, :interest_read, :integer
  end
end
