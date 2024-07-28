class ApplicationController < ActionController::API
  
    private  
    def authenticate_user!
      head :unauthorized if token_is_invalid?
    end
  
    def token_is_invalid?
      return true unless request.headers['Authorization'].present? 
  
      jwt_payload = JWT.decode(
        request.headers['Authorization'].split(' ').last, 
        ENV['DEVISE_JWT_SECRET_KEY']
      ).first rescue nil
  
      token_is_revoked?(jwt_payload)
    end
  
    def token_is_revoked?(jwt_payload)
      is_revoked = false
      return true if jwt_payload.nil?
      
      is_revoked = JwtDenylist.exists?(jti: jwt_payload["jti"])
      @current_user_id = jwt_payload["sub"] unless is_revoked
      is_revoked
    end
  end