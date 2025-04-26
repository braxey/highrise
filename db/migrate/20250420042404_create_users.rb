class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email_address, null: false, limit: 255
      t.string :password_digest, null: false
      t.string :first_name
      t.string :last_name
      t.boolean :is_active, default: true
      t.timestamps
    end
    add_index :users, :email_address, unique: true
  end
end
