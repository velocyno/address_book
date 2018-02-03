class ChangeAddressUrlColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :addresses, :url, :website
  end
end
