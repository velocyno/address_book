class ChangeAddressCardType < ActiveRecord::Migration[5.0]
  def change
    change_column(:addresses, :card, :boolean, 'USING card:boolean')
  end
end
