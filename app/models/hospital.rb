# encoding: utf-8
class Hospital < ActiveRecord::Base
  attr_accessible :description, :name, :namefull
  has_many :users, :dependent => :restrict
  has_many :patients, :dependent => :restrict

  before_validation :trim_string_fields

  #нужно: длина поля description 255 символов
  #длина поля name 50 символов
  #длина поля namefull 100 символов
  #name, namefull - не пусто
  #name - уникально в верхнем регистре
  validates :name, :length => { :maximum => 50 , :message =>  'Длина поля "Наименование" должна быть <=50 символов' }
  validates :namefull, :length => { :maximum => 100  , :message => 'Длина поля "Полное наименование" должна быть <=100 символов'}
  validates :description, :length => { :maximum => 254 , :message => 'Длина поля "Примечание" должна быть <=254 символов'}
  validates :name, :uniqueness =>  { :case_sensitive => false  , :message => 'Поле "Наименование" не уникально'}
  validates :name, :presence => { :message => 'Поле "Наименование" должно быть заполнено'}
  validates :namefull, :presence => { :message => 'Поле "Полное наименование" должно быть заполнено'}

 private

  #удаляет все ведущие и завершающие пробелы из строковых полей
  def trim_string_fields
    name.strip!
    namefull.strip!
    description.strip!
  end
end
