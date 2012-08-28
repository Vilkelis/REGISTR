class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :name_f
      t.string :name_i
      t.string :name_o
      t.integer :sex
      t.date :birth_date
      t.string :address
      t.string :work_place
      t.string :work_position
      t.string :description
      t.timestamps
    end
  end
end
