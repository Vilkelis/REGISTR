class AddDescriptionUsers < ActiveRecord::Migration
  def up
     add_column :users, :description , :string
  end

  def down
    remove_column :users, :description
  end
end
