class Cpanel::ApplicationController < ActionController::Base
  layout 'cpanel'
  protect_from_forgery with: :exception
end
