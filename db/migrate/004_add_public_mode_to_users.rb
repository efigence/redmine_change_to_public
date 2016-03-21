class AddPublicModeToUsers < ActiveRecord::Migration
  def up
    add_column :users, :public_mode, :boolean, default: false
  end

  def down
    remove_column :users, :public_mode
  end
end
