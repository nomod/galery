class ImagesController < ApplicationController

  #добавляем фото
  def add_image
      #здесь ловим параметр :mass_images вместо image
      #если передан массив :mass_images, то перебираем его и делаем записи в базу
      if params[:mass_images]
        @images = params[:mass_images]
        @images.each do |image|
          Image.create(image: image, album_id: params[:id])
        end
        flash[:success] = 'Фото добавлены!'
        redirect_to current_album
      end
  end


  #удаляем фото
  def destroy
      #id фото, которые отметили на удаление
      @img_id = params[:images][:image]

      #перебираем все отмеченные фото и удаляем их из базы
      if !@img_id.nil?
        @img_id.each do |id|
          @image_name = Image.find_by(id: id).image
          #удаляем фото из папки альбома
          File.delete("#{Rails.root}/public#{@image_name}")
          File.delete("#{Rails.root}/public#{@image_name.fill}")
          #удаляем из базы
          Image.find_by(id: id).destroy
        end
        flash[:success] = 'Фотографии удалены!'
        redirect_to edit_album_path
      end
  end

  private

  def current_album
    @current_album = Album.find_by(id: params[:id])
  end

end