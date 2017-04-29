class FormMailer < ApplicationMailer
  default from: 'admin@ryabchenko_foto.ru'

  def service_email(user)
    @user = user
    #если нужно на несколько адресов
    #mail(to: 'nomod@list.ru', subject: 'Тема письма', :bcc => ["m.ryadn@gmail.com", "ryadn@yandex.ru"])
    mail(to: "#{@user.email}", subject: 'Регистрация пользователя')
  end

  def confirmation_email(user)
    @user = user
    mail(to: 'm.ryadn@gmail.com', subject: 'Подтверждение регистрации')
  end

  def reset_email(user)
    @user = user
    mail(to: "#{@user.email}", subject: 'Сброс пароля')
  end

  def after_update_password(user)
    @user = user
    mail(to: "#{@user.email}", subject: 'Пароль обновлен')
  end
end