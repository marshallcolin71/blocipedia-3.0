class ApplicationController < ActionController::Base
  include pundit
  protect_from_forgery with: :exception
end
