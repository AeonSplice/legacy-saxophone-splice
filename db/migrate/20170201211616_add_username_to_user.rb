class AddUsernameToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :username, :string

    User.reset_column_information

    User.all.each do |user|
      user.username = 'Player 3.14'
      user.save!
    end

    change_column_null :users, :username, false
  end
end
