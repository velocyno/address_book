class AddColumnsToAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :card, :string
    add_column :addresses, :interests, :string
    add_column :addresses, :phone, :string
    add_column :addresses, :file, :binary
    add_column :addresses, :url, :string
    add_column :addresses, :number, :integer
    add_column :addresses, :color, :string
  end
end
