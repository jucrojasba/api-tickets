class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.string :name
      t.integer :capacity

      t.timestamps
    end
  end
end
