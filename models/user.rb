class User < ActiveRecord::Base
  include BCrypt
  attr_accessor :password, :password_confirmation
  default_scope {order('id DESC')}

  def initialize(params)
    super(params)
    self.encrypted_password = Password.create(params[:password]) if params[:password] && params[:password_confirmation] && params[:password] == params[:password_confirmation]
    self
  end

  def authenticate(password)
    if Password.new(self.encrypted_password) == password
      self.token = SecureRandom.base64
      self.save
      self
    else
      nil
    end
  end

  def organizations
    Organization.where(administrator_id: self.id)
  end

  def logout
    self.token = nil
    self.save
  end
end
