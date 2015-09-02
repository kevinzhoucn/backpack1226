class Mobile::FrontController < Mobile::ApplicationController
  def index
    render text: 'Hello'
  end

  def datetime
    datetime = DateTime.now
    render json: {datetime: datetime}
  end

  def create_user
    username = params[:username]
    password = params[:password]
    user = User.new(email: username, password: "12345678")

    if user.save
      if user.update_attributes(encrypted_password: password)
        render json: {result: 0, message: "Succeed! Create User!", username: username}
      end
    else
      render json: {result: 1, message: "Failed! Create User failed!", username: username}
    end
  end

  def signin_user
    username = params[:username]
    password = params[:password]
    user = User.where(email: username, encrypted_password: password).first

    if user
      render json: {result: 0, message: "Succeed! Login User!", username: username}
    else
      render json: {result: 1, message: "Failed! Login failed!", username: username}
    end
  end
end