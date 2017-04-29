class UpdateEmailsController < ApplicationController

  def edit
    @user = current_user
  end

  #обновляем email
  def update
    @user = current_user
    if @user.update_attributes(email_params)

      #сбрасываем email_confirmed и status, если пользователь захотел обновить email и формируем новый confirm_token
      @user.reset_email_confirmed_status

      #отправляем уведомление пользователю об обновлении почты с подтверждением этой почты
      @user.send_email_after_update_email

      #выходим из аккаунта
      sign_out

      flash[:success] = 'Обновлено! На почте письмо для подтверждения.'
      redirect_to root_path
    else
      flash[:error] = 'Что то пошло не так!'
      render 'edit'
    end
  end

  private

  def email_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end


end