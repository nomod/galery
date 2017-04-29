class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)

    #если пользователь с такой почтой существует и у него в базе есть введенный пароль
    if @user && @user.authenticate(params[:session][:password])
      #если у пользователя в базе email_confirmed = true, т.е. подтвержден
      if @user.email_confirmed
        #если пользователя проверил и утвердил админ
        if @user.status
          sign_in(@user)
          redirect_to albums_path
        else
          flash.now[:error] = 'Аккаунт на модерации!'
          render 'new'
        end
      else
        flash.now[:error] = 'Вы не прошли подтверждение по почте!'
        render 'new'
      end
    else
      flash.now[:error] = 'Неправильная пара логин/пароль'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end