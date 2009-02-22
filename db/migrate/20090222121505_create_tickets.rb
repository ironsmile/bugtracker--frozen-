class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      
      t.integer :project_id
      t.string :name
      t.text :description
      t.integer :version_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
