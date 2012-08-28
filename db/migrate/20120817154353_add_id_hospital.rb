class AddIdHospital < ActiveRecord::Migration
  def up
     add_column :users, :hospital_id , :integer
  end

  def down
    remove_column :users, :hospital_id
  end
end
