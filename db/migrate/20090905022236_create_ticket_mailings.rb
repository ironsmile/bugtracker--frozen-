class CreateTicketMailings < ActiveRecord::Migration
  def self.up
    create_table :ticket_mailings do |t|
      t.integer :user_id
      t.integer :ticket_id

      t.timestamps
    end
  end

  def self.down
    drop_table :ticket_mailings
  end
end
