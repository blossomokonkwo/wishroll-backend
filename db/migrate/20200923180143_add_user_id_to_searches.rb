class AddUserIdToSearches < ActiveRecord::Migration[6.0]
  def change
    add_column :searches, :user_id, :bigint, references: true, null: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end