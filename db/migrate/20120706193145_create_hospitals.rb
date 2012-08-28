class CreateHospitals < ActiveRecord::Migration
  def change
    create_table :hospitals do |t|
      t.string :name
      t.string :namefull
      t.string :description

      t.timestamps
    end
  end
end
