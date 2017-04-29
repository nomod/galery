class User < ApplicationRecord

  before_save :create_email
  before_create :create_remember_token, :create_confirm_token

  has_many :albums

  ########валидация при регистрации########

  validates_presence_of :user_name, :surname, :email, message: 'Заполните поле'
  validates_length_of :user_name, :surname, minimum: 3, message: 'Минимальная длина 3 символа'
  validates_format_of :user_name, :surname, with: /[\u0410-\u044F]+/i, message: 'пишите русскими буквами'
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: 'неккоректный формат'

  #проверка уникальности email в базе с учетом регистра
  validates_uniqueness_of :email, case_sensitive: false

  validates_length_of :password, minimum: 6, message: 'Минимальная длина 6 символов'

  #создание виртуальных полей и проверка на наличие и совпадения password и password_confirmation
  # + шифрует для записи в базу User.password_digest с использованием gem 'bcrypt'
  has_secure_password

  #активация аккаунта через почту
  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(validate: false)
  end

  #формируем токен и временную отсечку для сброса пароля
  def reset_digest
    update_attribute(:reset_password, Digest::SHA1.hexdigest(SecureRandom.urlsafe_base64))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  #высылаем письмо для сброса пароля
  def send_password_reset_email
    FormMailer.reset_email(self).deliver_now
  end

  #сбрасываем reset_password и reset_sent_at после обновления пароля
  def reset_after_password_update
    self.reset_password = nil
    self.reset_sent_at = nil
    save!(validate: false)
  end

  #сбрасываем email_confirmed и status, если пользователь захотел обновить email и формируем новый confirm_token
  def reset_email_confirmed_status
    self.email_confirmed = false
    self.status = false
    self.confirm_token = Digest::SHA1.hexdigest(SecureRandom.urlsafe_base64)
  end

  #высылаем письмо для подтверждения email после смены email
  def send_email_after_update_email
    FormMailer.service_email(self).deliver_now
  end

  #утверждение пользователя админом
  def public_user
    self.status = true
    save!(validate: false)
  end

  #снятие пользователя админом
  def no_public_user
    self.status = false
    save!(validate: false)
  end

  private

  #пишем в базу User.remember_token
  def create_remember_token
    #Digest - библиотека, SHA1 - алгоритм хеширования, hexdigest - метод
    #SecureRandom - модуль, urlsafe_base64 - метод возвращает случайную строку длиной в 16 символов
    #SecureRandom.urlsafe_base64 - это сам токен из случайных 16 символов
    #Digest::SHA1.hexdigest - шифруем токен
    self.remember_token = Digest::SHA1.hexdigest(SecureRandom.urlsafe_base64)
  end

  #пишем в базу User.confirm_token для подтверждения регистрации по почте
  def create_confirm_token
    if self.confirm_token.blank?
      self.confirm_token = Digest::SHA1.hexdigest(SecureRandom.urlsafe_base64)
    end
  end

  #сохраняем в базу поле User.email в нижнем регистре
  def create_email
    self.email = email.downcase
  end

end