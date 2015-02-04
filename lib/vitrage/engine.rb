module Vitrage
  class Engine < ::Rails::Engine
    isolate_namespace Vitrage
    require 'jquery-rails'
    require 'formtastic'
    require 'evil_icons'
  end
end
