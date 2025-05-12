class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.string :email_address, null: false
      t.references :notifiable, polymorphic: true, null: false
      t.string :message, null: false
      t.boolean :read, default: false

      t.timestamps
    end

    add_index :notifications, :email_address
    add_index :notifications, :read
  end
end
