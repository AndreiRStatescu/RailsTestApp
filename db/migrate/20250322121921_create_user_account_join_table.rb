class CreateUserAccountJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_join_table :users, :accounts do |t|
      t.index [:user_id, :account_id], unique: true
      t.index [:account_id, :user_id]
    end
  end
end
