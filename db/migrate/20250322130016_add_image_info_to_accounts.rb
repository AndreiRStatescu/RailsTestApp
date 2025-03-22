class AddImageInfoToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :image_key, :string
  end
end
