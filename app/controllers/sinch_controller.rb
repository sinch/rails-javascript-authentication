class SinchController < ApplicationController
	before_action :authenticate_user!
	
  def index
    @ticket = session[:ticket]
  	session[:ticket] = nil

  	redirect_to new_user_session_path if @ticket == nil
  end
end
