class AlbumsController < ApplicationController

  #чтобы редактировать, обновлять и просматривать нужно войти
  before_action :signed_in_user, only: [:show, :edit, :update, :select_image]
  #возможность редактировать, обновлять только свои альбомы
  before_action :correct_user, only: [:edit, :update]
  #возможность просматривать только свои альбомы, либо обще-публичные
  before_action :publish_album, only: [:show, :select_image]

  def index
    #публичные альбомы пользователя
    @all_albums_public_user = Album.where(user_id: current_user.id, status_id: 1).order(:id)
    #хэш с названиями альбомов
    @albums_name_public_user = {}
    #хэш фото в каждом из альбомов
    @fotos_hash_public_user = {}

    @all_albums_public_user.each do|album|
      @fotos_in_album_public_user = Image.where(album_id: album.id)

      @fotos_hash_public_user["#{album.id}"] = @fotos_in_album_public_user
      @albums_name_public_user["#{album.id}"] = album.album_name
    end

    #приватные альбомы пользователя
    @all_albums_private_user = Album.where(user_id: current_user.id, status_id: 2).order(:id)
    #хэш с названиями альбомов
    @albums_name_private_user = {}
    #хэш фото в каждом из альбомов
    @fotos_hash_private_user = {}

    @all_albums_private_user.each do|album|
      @fotos_in_album_private_user = Image.where(album_id: album.id)

      @fotos_hash_private_user["#{album.id}"] = @fotos_in_album_private_user
      @albums_name_private_user["#{album.id}"] = album.album_name
    end

    #все обще-публичные альбомы, кроме альбомов текущего пользователя
    @all_albums_public = Album.where.not(user_id: current_user.id).where(status_id: 1).order(:id)
    #хэш с названиями альбомов
    @albums_name_public = {}
    #хэш фото в каждом из альбомов
    @fotos_hash_public = {}
    #хэш владельцев альбомов
    @owner_hash_public = {}

    @all_albums_public.each do|album|
      @fotos_in_album_public = Image.where(album_id: album.id)

      @user_id = Album.find_by(id: album.id).user_id
      @owner_name = User.find_by(id: @user_id).user_name
      @owner_surname = User.find_by(id: @user_id).surname
      @owner = "#{@owner_name}" + ' ' "#{@owner_surname}"

      @fotos_hash_public["#{album.id}"] = @fotos_in_album_public
      @albums_name_public["#{album.id}"] = album.album_name
      @owner_hash_public["#{album.id}"] = @owner
    end
  end

  def show
    #выводим все фото в текущем альбоме
    @all_foto_album = Album.find_by(id: params[:id]).images

    #текущий пользователь относительно альбома
    @id_user = Album.find_by(id: params[:id]).user_id
    @user = User.find_by(id: @id_user)

    #@album = Album.new
    @current_album = current_album
  end

  def new
    @album = Album.new
    @status = StatusAlbum.all
  end

  def create

    @album_name = Album.find_by(album_name: params[:album][:album_name])
    @album_user_id = Album.find_by(user_id: params[:album][:user_id])

    #если альбом с таким названием у такого пользователя есть
    if @album_name && @album_user_id
      @album = Album.new
      @status = StatusAlbum.all
      flash[:error] = 'У вас уже есть альбом с таким названием!'
      render 'new'
      #если нет, то создаем альбом
    else
      @album = Album.new(album_params)
      if @album.save
        flash[:success] = 'Поздравляем, вы создали новый альбом!'
        redirect_to @album
      else
        @status = StatusAlbum.all
        render 'new'
      end
    end

  end

  def edit
    @current_album = current_album
    #все фото в данном альбоме
    @all_foto = Image.where(album_id: params[:id])
  end

  #обновляем название альбома
  def update
      @album = current_album
      if @album.update_attributes(album_params)
        flash[:success] = 'Название альбома обновлено!'
        redirect_to edit_album_path
      else
        #все фото в данном альбоме
        @all_foto = Image.where(album_id: params[:id])
        render 'edit'
      end
  end

  #удаляем альбом
  def destroy
    @album = current_album

    #все фото в данном альбоме
    @album_id = Album.find_by(id: params[:id])
    @fotos_in_albom = Image.where(album_id: @album_id)
    #проходим в цикле по папке и удаляем изображения из этого альбома
    @fotos_in_albom.each do |foto|
      File.delete("#{Rails.root}/public#{foto.image}")
      File.delete("#{Rails.root}/public#{foto.image.fill}")
    end
    #удаляем саму папку альбома
    FileUtils.rm_rf("#{Rails.root}/public/images/#{@album.id}")

    if @album.destroy
      flash[:notice] = "Альбом '#{@album.album_name}' удален!"
      redirect_to albums_path
    else
      redirect_to @album
    end
  end


  private

  def album_params
    params.require(:album).permit(:album_name, :user_id, :status_id)
  end

  def signed_in_user
    #если текущий пользователь пустой
    if current_user.nil?
      flash[:notice] = 'Авторизуйтесь для продолжения!'
      redirect_to signin_url
    end
  end

  def correct_user
    @id_user = Album.find_by(id: params[:id]).user_id
    @user = User.find_by(id: @id_user)
    #если пользователь не равен текущему, то отправляем его на свою страницу
    if @user != current_user
      flash[:notice] = 'Это не ваш альбом!'
      redirect_to(albums_path)
    end
  end

  def current_album
      @current_album = Album.find_by(id: params[:id])
  end

  def publish_album
    if !current_album.nil?
      @id_user = Album.find_by(id: params[:id]).user_id
      @user = User.find_by(id: @id_user)
      #если пользователь не равен текущему и альбом не является обще-публичным, то отправляем на свою страницу
      if @user != current_user && current_album.status_id == 2
        flash[:notice] = 'Это не ваш приватный альбом!'
        redirect_to(albums_path)
      end
    else
      flash[:notice] = 'Почему то такого альбома нет!'
      redirect_to(albums_path)
    end

  end

end