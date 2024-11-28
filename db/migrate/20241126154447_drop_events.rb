class DropEvents < ActiveRecord::Migration[7.2]
  def change
    drop_table :events if table_exists?(:events)
  end
end
