class RemovePublicModeFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :public_mode
  end

  def down
    add_column :users, :public_mode, :boolean, default: false
  end
end
