class UsersController < ApplicationController

  #чтобы редактировать, обновлять, удалять и просматривать нужно войти
  before_action :signed_in_user, only: [:show, :edit, :update, :destroy]
  #возможность редактировать, обновлять, удалять и просматривать только свой профиль
  before_action :correct_user, only: [:show, :edit, :update, :destroy]


  def index
    @user = User.new
    #если текущий юзер - админ, то получаем инфу по всем юзерам
    if !current_user.nil? && admin?
      @users =  User.all
    end
  end

  def show

  end

  def new
    @user = User.new
  end

  def create

    #утверждаем пользователя после регистрации админом
    if params[:public_btn]
      @user_public = User.find_by_id(params[:user][:user_id])
      respond_to do |format|
        if @user_public.public_user
          format.json { render json: {user: @user_public, status: 'утверждено'} }
        else
          format.json { render json: {user: 'Статус не обновился'}, status: 423 }
        end
      end

    #снимаем пользователя после регистрации админом
    elsif params[:nopublic_btn]
      @user_public = User.find_by_id(params[:user][:user_id])
      respond_to do |format|
        if @user_public.no_public_user
          format.json { render json: {user: @user_public, status: 'снят'} }
        else
          format.json { render json: {user: 'Статус не обновился'}, status: 423 }
        end
      end

    #иначе регистрация пользователя
    else
      @user = User.new(user_params)
      if @user.save

        #отправляем уведомление о регистрации на почту пользователя
        FormMailer.service_email(@user).deliver_now

        flash[:success] = 'Вы зарегистрировались! На почте письмо для подтверждения.'
        redirect_to root_path
      else
        flash[:error] = 'Что то пошло не так!'
        render 'new'
      end
    end
  end

  #подтверждение регистрации по почте
  def confirm_email
    @user = User.find_by_confirm_token(params[:id])
    if @user
      @user.email_activate
      flash[:success] = 'Поздравляем, ваш профиль подтвержден!'
      redirect_to signin_url

      #отправляем уведомление админу о том, что пользователь подтвердил себя по почте
      FormMailer.confirmation_email(@user).deliver_now
    else
      flash[:error] = 'Профиль не подтвержден!'
      redirect_to root_path
    end
  end

  def edit

  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'Профиль обновлен!'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'Вы удалены!'
    redirect_to root_path
  end

  #утверждаем или снимаем пользователя
  def public_user

  end


  private

  def signed_in_user
    #если текущий пользователь пустой
    if current_user.nil?
      flash[:notice] = 'Авторизуйтесь для продолжения!'
      redirect_to signin_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    #если пользователь не равен текущему или админу, то отправляем его на свою страницу
    if @user != current_user && !admin?
      redirect_to(current_user)
    end
  end

  def user_params
    params.require(:user).permit(:user_name, :surname, :email, :password, :password_confirmation)
  end

end