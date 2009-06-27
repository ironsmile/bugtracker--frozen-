class UsersAddGroupId < ActiveRecord::Migration
  def self.up
    add_column :users, :group_id, :integer
    remove_column :users, :user_type_id
  end

  def self.down
    remove_column :users, :group_id
    add_column :users, :user_type_id, :integer, :default => 0
  end
end
