class AddUserDisabledColumn < ActiveRecord::Migration
  def change
    add_column :users, :disabled, :boolean, default: false
  end
end
