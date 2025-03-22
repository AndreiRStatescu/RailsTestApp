class AddUrlsToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :urls, :json
  end
end
