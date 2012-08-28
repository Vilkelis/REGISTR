class AddAfterInvalidToPatients < ActiveRecord::Migration
  def change
     add_column :patients, :after_invalid, :string                               #Инвалидность после операции - степень
     add_column :patients, :after_invalid_descr, :string                         #Инвалидность после операции - причина
  end
end
