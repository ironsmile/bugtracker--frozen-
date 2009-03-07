class CreatePhases < ActiveRecord::Migration
  def self.up
    create_table :phases do |t|
    
      t.string :name
      
      t.timestamps
    end
  end

  def self.down
    drop_table :phases
  end
end
