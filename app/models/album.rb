class Album < ApplicationRecord

  belongs_to :user
  has_many :images, dependent: :delete_all

  validates_presence_of :album_name, message: 'заполните поле'
  validates_length_of :album_name, minimum: 3, message: 'минимальная длина 3 символа'
  validates_format_of :album_name, with: /[\u0410-\u044F]+/i, message: 'пишите русскими буквами'

end