class UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]
  before_action :current_user, only: [:edit, :update, :destroy]

  def profile
    render json: { user: User.new(current_user) }, status: :accepted
  end

  def new
    user = User.new(user_params)
    render json: user
  end

  def create
    user = User.create(user_params)
    if user.valid?
      token = encode_token(user_id: user.id)
      render json: { user: user, jwt: token }, status: :created
    else
      render json: { error: 'failed to create user' }, status: :not_acceptable
    end
  end

  def edit
  end

  def update
    user.update(user_params)
  end

  def destroy
    user.destroy
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :username, :note, :notes)
  end
end

  # def current_user
  #   if decoded_token
  #     user_id = decoded_token[0]['user_id']
  #     user = User.find_by(id: user_id)
  #   end 
  # end