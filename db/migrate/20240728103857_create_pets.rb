class CreatePets < ActiveRecord::Migration[7.1]
  def change
    create_table :pets do |t|
      t.string :type # STI column
      t.integer :owner_id, null: false
      t.boolean :in_zone, default: true
      t.boolean :lost_tracker # Specific to Cat
      t.integer :tracker_type, null: false, default: 0
      t.timestamps
    end

    add_index :pets, :type
    add_index :pets, :owner_id
    add_index :pets, :in_zone
  end
end
