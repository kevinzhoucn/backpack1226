class Cpanel::ApplicationController < ActionController::Base
  layout 'appprofile'
  protect_from_forgery with: :exception

  before_filter :authenticate_user!
end
