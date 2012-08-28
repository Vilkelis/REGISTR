class AddColumnsToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :before_invalid, :string                               #Инвалидность до операции - степень
    add_column :patients, :before_invalid_descr, :string                         #Инвалидность до операции - причина

    add_column :patients, :weight, :decimal                                          #Вес
    add_column :patients, :height, :decimal                                          #Рост

    add_column :patients, :imt, :decimal                                          #ИМТ
    add_column :patients, :imt_cond, :decimal                                     #Степень ожирения
    add_column :patients, :is_nasled, :integer					                              # { headerText: 'Наследственность', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200},
    add_column :patients, :is_smoke, :integer					                              # { headerText: 'Курение', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200},
    add_column :patients, :is_art_giper, :integer					                           #    { headerText: 'Артериальная гипертония', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200},
    add_column :patients, :is_sahar_diabet, :integer					                         #      { headerText: 'Сахарный диабет', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200},
    add_column :patients, :glukoza, :decimal					                              # { headerText: 'Глюкоза крови, ммоль/л', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200},
    add_column :patients, :oh_before, :decimal					                            #   { headerText: 'ОХ до операции,ммоль/л', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200},
    add_column :patients, :oh_in_hospital, :decimal                                  #  { headerText: 'ОХ в отделении, ммоль/л', data


# { headerText: 'Клиническая характеристика',

add_column :patients, :stenokard, :decimal					                                #{ headerText: 'Стенокардия, функц.класс', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200},
add_column :patients, :is_anevrizm, :integer					                             #   { headerText: 'Аневризм ЛЖ', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200},
add_column :patients, :onmk_year, :integer					                              #  { headerText: 'ОНМК, год', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200},
add_column :patients, :pik_year, :integer					                               # { headerText: 'ПИК, год', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200},
add_column :patients, :xch, :string					                               # { headerText: 'ХСН по NYHA', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200},
add_column :patients, :xch_class, :integer					                        #        { headerText: 'ХСН функц.класс', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200}

# { headerText: 'Ангиографическая характеристика',

#       { headerText: 'Поражение кор.русла',

add_column :patients, :sosud_qty, :integer					                                    # { headerText: 'Кол-во пораж. сосудов', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200},
add_column :patients, :is_sosud_75, :integer					                                   #  { headerText: '75 и окклюзия', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200}

#        { headerText: 'Фракция выброса ЛЖ',

add_column :patients, :fb_before,:integer					                                   #  { headerText: 'ФВ до операции', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200},
add_column :patients, :fb_after,:integer					                                   #  { headerText: 'ФВ п/операции', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200}

#        { headerText: 'Левое предсердие',

add_column :patients, :lp_before,:integer					                                    # { headerText: 'ЛП до операции', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200},
add_column :patients, :lp_after,:integer					                                    # { headerText: 'ЛП п/операции', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200}

#    { headerText: 'Сведения об операции',

add_column :patients, :oper_date,:date					                               #  { headerText: 'Дата операции', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200},
add_column :patients, :oper_type,:string					                              #   { headerText: 'Тип операции', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200},
add_column :patients, :oper_result,:string					                             #    { headerText: 'Исход операции', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200}


#{headerText: 'РЕАБИЛИТАЦИЯ',

add_column :patients, :is_napravlen,:integer      #  { headerText: 'Направлен ', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200},
add_column :patients, :hospital_id,:integer       #  { headerText: 'ЛПУ', dataKey: "before_invalid", allowSort: true,  ensurePxWidth: true, width: 200}


#           {headerText: 'АМБУЛАТОРНЫЙ ЭТАП',
add_column :patients, :fate,:string  # columns: [  { headerText: 'Судьба в отдаленном периоде'},
add_column :patients, :death_year,:integer #                           { headerText: 'Год смерти'}


  end
end
