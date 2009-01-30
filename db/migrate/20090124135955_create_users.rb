class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :full_name
      t.string :email
      t.string :password
      t.integer :user_type_id, :default => 0
      t.string :persistent_login
      
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
