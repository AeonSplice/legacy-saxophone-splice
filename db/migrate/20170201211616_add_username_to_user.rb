class AddUsernameToUser < ActiveRecord::Migration[5.0]
  def change
    add_column         :users, :username, :string
    change_column_null :users, :username, false
    add_index          :users, :username, unique: true
  end
end
