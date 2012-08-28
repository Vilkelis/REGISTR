# encoding: utf-8
class Patient < ActiveRecord::Base
  attr_accessible :name_f,
                  :name_i,
                  :name_o ,
                  :sex,
                  :birth_date,
                  :address,
                  :work_place,
                  :work_position,
                  :description,

                  :before_invalid, #Инвалидность до операции - степень
                  :before_invalid_descr, #Инвалидность до операции - причина

                  :weight, #Вес
                  :height, #Рост
                  :imt, #ИМТ
                  :imt_cond, #Степень ожирения
                  :is_nasled, # 'Наследственность'
                  :is_smoke, # 'Курение'
                  :is_art_giper, #    'Артериальная гипертония'
                  :is_sahar_diabet, # 'Сахарный диабет'
                  :glukoza, # 'Глюкоза крови, ммоль/л'
                  :oh_before, #   'ОХ до операции,ммоль/л'
                  :oh_in_hospital, #  'ОХ в отделении, ммоль/л', data
                  # 'Клиническая характеристика',

                  :stenokard,   #'Стенокардия, функц.класс' :decimal
                  :is_anevrizm, # 'Аневризм ЛЖ' :integer
                  :onmk_year, 		#  'ОНМК, год' :integer
                  :pik_year, 			# 'ПИК, год' :integer
                  :xch, 			  # 'ХСН по NYHA' :string
                  :xch_class, 		# 'ХСН функц.класс' :integer

                  # 'Ангиографическая характеристика',
                  #       'Поражение кор.русла',
                 :sosud_qty,     # 'Кол-во пораж. сосудов' :integer
                 :is_sosud_75, 		# '75 и окклюзия' :integer

                  #        'Фракция выброса ЛЖ',
                  :fb_before, #  'ФВ до операции' :integer
                  :fb_after, #  'ФВ п/операции':integer

                  #        'Левое предсердие',
                  :lp_before, # 'ЛП до операции' :integer
                  :lp_after, # 'ЛП п/операции' :integer

                  #    'Сведения об операции'
                  :oper_date,			#  'Дата операции' :date
                  :oper_type,		#  'Тип операции' ,:string
                  :oper_result,	#  'Исход операции',:string

                  # 'РЕАБИЛИТАЦИЯ',
                  :is_napravlen,     #  'Направлен ',:integer
                  :hospital_id,      #  'ЛПУ' ,:integer

                  #           'АМБУЛАТОРНЫЙ ЭТАП',
                 :fate,         # 'Судьба в отдаленном периоде',:string
                 :death_year , # 'Год смерти',:integer

                  :after_invalid,  #Инвалидность после операции - степень
                  :after_invalid_descr  #Инвалидность после операции - причина

  LIST_VALUES_INVALID = ["нет","I группа","II группа","III группа"]
  LIST_VALUES_OPER_TYPE=["-","МКШ","АКШ","МКШ, АКШ","резекция аневризмы, МКШ, АКШ"]
  LIST_VALUES_OPER_RESULT=["-","выписан","направлен на реабилитацию","умер"]
  LIST_VALUES_FATE=["жив","умер"]

  belongs_to :hospital

  before_validation :trim_string_fields

  validates :name_f, :presence => { :message => 'Поле "Фамилия" должно быть заполнено'}
  validates :name_i, :presence => { :message => 'Поле "Имя" должно быть заполнено'}
  validates :name_o, :presence => { :message => 'Поле "Отчество" должно быть заполнено'}
  validates :sex, :presence => { :message => 'Поле "Пол" должно быть заполнено'}
  validates :sex, :inclusion => {:in=>[1,2], :message => 'Поле "Пол" должно принимать значение 2 (мужской) или 1 (женский).'}

  validates :name_f, :length => { :maximum => 100  , :message => 'Длина поля "Фамилия" должна быть <=100 символов'}
  validates :name_i, :length => { :maximum => 100  , :message => 'Длина поля "Имя" должна быть <=100 символов'}
  validates :name_o, :length => { :maximum => 100  , :message => 'Длина поля "Отчество" должна быть <=100 символов'}

  validates :description, :length => { :maximum => 254 , :message => 'Длина поля "Примечание" должна быть <=254 символов'}

  validates :address, :length => { :maximum => 254 , :message => 'Длина поля "Адрес" должна быть <=254 символов'}
  validates :work_place, :length => { :maximum => 254 , :message => 'Длина поля "Место работы" должна быть <=254 символов'}
  validates :work_position, :length => { :maximum => 254 , :message => 'Длина поля "Должность" должна быть <=254 символов'}

  validates :before_invalid, :inclusion => {:in=>LIST_VALUES_INVALID, :message => 'Неверное значение поля "Инвалидность до операции".'}
  validates :after_invalid, :inclusion => {:in=>LIST_VALUES_INVALID, :message => 'Неверное значение поля "Инвалидность после операции".'}

 private

  #удаляет все ведущие и завершающие пробелы из строковых полей
  def trim_string_fields
    name_f.strip!
    name_i.strip!
    name_o.strip!
    description.strip!
    address.strip!
    work_place.strip!
    work_position.strip!
  end
end
