class ChangeImageKeyToImageKeysInAccounts < ActiveRecord::Migration[8.0]
  def change
    # Remove the old string column
    remove_column :accounts, :image_key, :string
    
    # Add a new JSON column for storing multiple image keys
    add_column :accounts, :image_keys, :json, default: []
  end
end
