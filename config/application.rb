require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Foto
  class Application < Rails::Application

    #по умолчанию создаем файлы slim
    config.generators do |g|
      g.template_engine :slim
    end


    #для русской локали
    config.i18n.default_locale = :ru
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

  end
end