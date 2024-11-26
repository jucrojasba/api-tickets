class DropEvents < ActiveRecord::Migration[7.2]
  def change
    drop_table :events
  end
end
