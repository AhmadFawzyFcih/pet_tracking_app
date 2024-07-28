# spec/support/auth_helpers.rb
module AuthHelpers
    def generate_jwt_token(user)
      Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    end
end