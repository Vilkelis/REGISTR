# encoding: utf-8
require 'digest'   #Для использования алгоритмов шифрования
class User < ActiveRecord::Base
  attr_accessor :password, :no_change_password
  attr_accessible :email, :name, :namefull , :description , :password, :password_confirmation,  :no_change_password, :role,:hospital_id
  belongs_to :hospital

  before_validation :trim_string_fields
  before_save :encrypt_password

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  ROLE_NONE ='Нет доступа'
  ROLE_ADMIN = 'Администратор'
  ROLE_EDITOR = 'Редактор'
  ROLE_ANALYTIC = 'Аналитик'
  ROLE_EDITOR_ANALYTIC = 'Редактор и  Аналитик'
  ROLE_VALUES =  [ROLE_EDITOR,ROLE_ANALYTIC,ROLE_EDITOR_ANALYTIC,ROLE_ADMIN, ROLE_NONE]

  validates :password, :presence => {:if => :can_change_password, :message => 'Не указан Пароль'}
  validates :password, :confirmation => {:if => :can_change_password,  :message => 'Пароль и подтвержение не совпадают'}
  validates :password, :length  => {:if => :can_change_password,  :within => 6..40, :message => 'Длина пароля должна быть >=6 и <=40 символов' }

  validates :name, :length => {:minimum => 6, :maximum => 50 , :message =>  'Длина поля "Код пользователя" должна быть >=6 и <=50 символов' }
  validates :namefull, :length => { :maximum => 100  , :message => 'Длина поля "Ф.И.О." должна быть <=100 символов'}
  validates :description, :length => { :maximum => 254 , :message => 'Длина поля "Примечание" должна быть <=254 символов'}
  validates :name, :uniqueness =>  { :case_sensitive => false  , :message => 'Поле "Код пользователя" не уникально'}
  validates :name, :presence => { :message => 'Поле "Код пользователя" должно быть заполнено'}
  validates :namefull, :presence => { :message => 'Поле "Ф.И.О." должно быть заполнено'}

  validates :email, :format => { :with => email_regex, :message => 'Не корректный формат поля "e-mail".' }, :allow_blank => true
  validates :email, :uniqueness => { :case_sensitive => false  ,  :message => 'Поле "e-mail" не уникально'}, :allow_blank => true
  validates :email, :length => { :maximum => 254 , :message => 'Длина поля "E-maul" должна быть <=254 символов'}

  validates :role, :presence => {:if => :can_change_password, :message => 'Не указана Роль пользователя'}
  validates :role, :inclusion => {:in=> ROLE_VALUES, :message => 'Значение в поле "Роль" указано неверно.'}

  validates :hospital_id, :presence => {:message => 'Поле "ЛПУ" должно быть заполнено.'}



  #Проверяет, совпадает ли пароль с паролем в базе данных
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(name, submitted_password)
    user = find_by_name(name)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end


  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    return nil  if user.nil?
    return user if user.salt == cookie_salt
  end

  def roles
      ROLE_VALUES
  end

  def blocked?
    role == ROLE_NONE
  end

 private

  #удаляет все ведущие и завершающие пробелы из строковых полей
  def trim_string_fields
    name.strip!
    namefull.strip!
    description.strip!
    email.strip!
    role.strip!
  end

  #-----------Работа с паролями--------------

  def encrypt_password
    if self.no_change_password != true then
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(self.password)
    end
  end

  def encrypt(string)
    secure_hash("#{self.salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

  def can_change_password
    self.no_change_password == false
  end
end
