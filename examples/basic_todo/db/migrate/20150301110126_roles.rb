class Roles < ActiveRecord::Migration
  class Role < ActiveRecord::Base
  end

  def change
    create_table :user_roles do |t|
      t.integer :user_id
      t.integer :role_id

      t.timestamps
    end

    create_table :roles do |t|
      t.string :name

      t.timestamps
    end

    Role.create!(name: 'account_holder')
    Role.create!(name: 'admin')
  end
end
