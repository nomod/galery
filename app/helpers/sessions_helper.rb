module SessionsHelper

  def sign_in(user)
    remember_token = SecureRandom.urlsafe_base64
    cookies.permanent[:remember_token] = remember_token

    #Digest - библиотека, SHA1 - алгоритм хеширования, hexdigest - метод
    #SecureRandom - модуль, urlsafe_base64 - метод возвращает случайную строку длиной в 16 символов
    #SecureRandom.urlsafe_base64 - это сам токен из случайных 16 символов
    #Digest::SHA1.hexdigest - шифруем токен
    user.update_attribute(:remember_token, Digest::SHA1.hexdigest(remember_token))
  end

  def current_user
    #поиск текущего пользователя в базе
    #выдергиваем из куки токен, шифруем его и ищем такой же в базе
    #to_s - нужен, если куки пустые
    remember_token = Digest::SHA1.hexdigest(cookies[:remember_token].to_s)

    #если @current_user nil, то выдергиваем из базы юзера, иначе возвращаем @current_user
    #@current_user ||= User.find_by(remember_token: remember_token)
    if @current_user.nil?
      @current_user = User.find_by(remember_token: remember_token)
    else
      @current_user
    end
  end

  def sign_out
    #создаем новый токен
    remember_token = SecureRandom.urlsafe_base64
    #пишем в базу новый зашифрованный токен User.remember_token
    current_user.update_attribute(:remember_token, Digest::SHA1.hexdigest(remember_token))
    #чистим куки
    cookies.delete(:remember_token)
  end

  #текущий пользователь админ или нет
  def admin?
    current_user.admin?
  end

end