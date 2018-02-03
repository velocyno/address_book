class ChangeAddressInterestType < ActiveRecord::Migration[5.0]
  def change
    change_column(:addresses, :interest_climb, :boolean)
    change_column(:addresses, :interest_dance, :boolean)
    change_column(:addresses, :interest_read, :boolean)
  end
end
