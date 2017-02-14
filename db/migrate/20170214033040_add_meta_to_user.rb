class AddMetaToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :locale,   :string, null: false, default: 'en'
    add_column :users, :timezone, :string, null: false, default: 'UTC'
    add_column :users, :realname, :string
    add_column :users, :nickname, :string
    add_column :users, :website,  :string
    add_column :users, :location, :string
    add_column :users, :bio,      :text
  end
end
