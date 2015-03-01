class Api < Grape::API
  format :json

  namespace :users do
    desc "Sign Up"
    params do
      requires :user, type: Hash do
        requires :password, type: String, desc: "Your Password."
        requires :password_confirmation, type: String, desc: "Your Password Confirmation."
        requires :email, type: String, desc: "Your Email."
        requires :first_name, type: String, desc: "Your First Name."
        requires :last_name, type: String, desc: "Your Last Name."
        requires :phone, type: String, desc: "Your Phone Number."
      end
    end
    post "/" do
      user = User.create(declared_params[:user])
      user.token = SecureRandom.base64
      user.save
      user = user.attributes
      user.delete("encrypted_password")
      user
    end

    desc "Sign In."
    params do
      requires :user, type: Hash do
        requires :password, type: String, desc: "Your Password."
        requires :email, type: String, desc: "Your Email."
      end
    end
    put "/" do
      user = User.find_by(email: params[:user][:email]).authenticate(params[:user][:password])
      if user
        user = user.attributes
        user.delete("encrypted_password")
        user
      end
    end

    desc "Sign Out."
    delete "/" do
      current_user.logout
    end
  end
end
