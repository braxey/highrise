class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
