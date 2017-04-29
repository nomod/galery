class MainController < ApplicationController
  def index
    #обще-публичные альбомы
    @all_albums = Album.where(status_id: 1).order(:id)
    #хэш фото в каждом из альбомов
    @fotos_hash = {}
    @all_albums.each do|album|
      @fotos_in_album = Image.where(album_id: album.id)
      @fotos_hash["#{album.id}"] = @fotos_in_album
    end
  end


end