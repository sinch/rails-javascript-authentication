class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(user)
    after(user.email)
  end

  def after_sign_up_path_for(user)
    after(user.email)
  end

  def after(email)
    session[:ticket] = get_auth_ticket(email)
    root_path
  end

  def get_auth_ticket(username)
    user_ticket = {
      "identity" => {"type" => "username", "endpoint" => username},
      "expiresIn" => 3600, #seconds
      "applicationKey" => "your_app_key",
      "created" => Time.now.utc.iso8601
    }

    user_ticket_json = user_ticket.to_json.gsub(/\s+/, "")
		user_ticket_base64 = Base64.encode64(user_ticket_json).strip
		digest = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), Base64.decode64("your_app_secret"), user_ticket_json).strip
		signature = Base64.encode64(digest).strip
		return (user_ticket_base64 + ':' + signature).gsub(/\s+/, "")
	end
end
