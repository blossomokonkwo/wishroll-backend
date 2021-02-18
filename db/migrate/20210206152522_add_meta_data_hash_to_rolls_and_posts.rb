class AddMetaDataHashToRollsAndPosts < ActiveRecord::Migration[6.1]
  enable_extension 'hstore' unless extension_enabled?('hstore')
  def change
    add_column :rolls, :metadata, :hstore, default: Hash.new, null: false
    add_column :posts, :metadata, :hstore, default: Hash.new, null: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end