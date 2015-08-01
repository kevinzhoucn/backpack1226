class Apiv00::ApplicationController < ActionController::Base
  layout 'apptest'
  protect_from_forgery with: :exception
end
