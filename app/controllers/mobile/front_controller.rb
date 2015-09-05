class Mobile::FrontController < Mobile::ApplicationController
  def index
    render text: 'Hello'
  end

  def post
    data = params[:data]
    render json: data.to_json
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
      new_token = Devise.friendly_token
      user.update_attributes(app_token: new_token)
      render json: {result: 0, message: "Succeed! Login User!", username: user.username, session: user.app_token}
    else
      render json: {result: 1, message: "Failed! Login failed!", username: user.username}
    end
  end
end