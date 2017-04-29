class ResetsController < ApplicationController

  before_action :get_user_before_edit, :valid_user, :check_expiration, only: [:edit]
  before_action :get_user_before_update, :valid_user, :check_expiration, only: [:update]

  def new
  end

  def create
    #находим пользователя в базе по введенной им почте
    @user = User.find_by_email(params[:reset][:email].downcase)
    if @user
      #обновляем токен и временную отметку
      @user.reset_digest
      #высылаем письмо для сброса на почту пользователя
      @user.send_password_reset_email

      flash[:success] = 'Отправлено письмо для восстановление пароля!'
      redirect_to root_url
    else
      flash.now[:error] = 'Такой почты нет!'
      render 'new'
    end
  end

  def edit
  end

  #обновляем пароль
  def update
    if @user.update_attributes(user_params)

      #отправляем уведомление пользователю о смене пароля
      FormMailer.after_update_password(@user).deliver_now

      sign_in(@user)
      flash[:success] = 'Пароль обновлен!'
      #сбрасываем reset_password и reset_sent_at после обновления пароля
      @user.reset_after_password_update
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :email)
  end

  #находим пользователя по переданному параметру e-mail в ссылке, по которой он перешел из почты для сброса пароля
  def get_user_before_edit
    @user = User.find_by_email(params[:email])
  end

  #находим пользователя по переданному параметру e-mail в скрытом поле формы
  def get_user_before_update
    @user = User.find_by_email(params[:user][:email])
  end

  #проверяем, что такой пользователь есть и он подтвержден по почте и что он пришел по ссылке с правильным токеном
  def valid_user
    #если эти условия не выполняются, то редиректим на главную
    if @user
      if @user.email_confirmed
        if @user.reset_password == params[:id]
        else
          flash[:error] = 'Неправильный токен!'
          redirect_to root_url
        end
      else
        flash[:error] = 'Пользователь не подтвержден по почте!'
        redirect_to root_url
      end
    else
      flash[:error] = 'Пользователя с такой почтой нет!'
      redirect_to root_url
    end
  end

  #проверка истекло время с момента отсылки письма для сброса пароля или нет
  def check_expiration
    if @user.reset_sent_at < 2.hours.ago
      flash[:error] = 'Время действия ссылки для восстановления пароля истекло!'
      redirect_to new_reset_url
    end
  end

end