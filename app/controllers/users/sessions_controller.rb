class Users::SessionsController < Devise::SessionsController
    respond_to :json
  
    private
  
    def respond_with(resource, _opts = {})
    msg, status= current_user.nil? ? ["Invalid Credentials", 401] : ["Logged in successfully.", 200]

    render json: {
        message: msg,
        user: current_user
      }, status: status
    end
  
    def respond_to_on_destroy
      render json: {
        message: 'Logged out successfully.'
      }, status: :ok
    end
  
    def verify_signed_out_user
      # Override to prevent the method from raising an error if user is not logged in
    end
end
  