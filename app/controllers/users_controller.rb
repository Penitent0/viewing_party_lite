
class UsersController < ApplicationController
  before_action :require_user, only: :show

  def show
    @user = User.find(session[:user_id])
    @movies = @user.viewing_parties.map { |party| MovieFacade.details_poro(party.movie_id) }
    @invitees = @user.viewing_parties.flat_map { |party| party.invitees(@user.id) }
  end

  def new; end

  def create
    user = user_params
    user[:email] = user[:email].downcase 
    new_user = User.new(user)
    if new_user.save
      session[:user_id] = new_user.id
      redirect_to(dashboard_path)
      flash.notice = 'User Registered Successfully'
    else
      flash.alert = new_user.errors.full_messages.to_sentence
      render :new
    end
  end

  def login_form

  end

  def login_user
    if !User.find_by(email: params[:email]).nil?
      user = User.find_by(email: params[:email])
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:success] = "Welcome, #{user.name}!"
        redirect_to(dashboard_path)
      else
        flash[:error] = "Password Incorrect"
        render :login_form
      end
    else
      flash[:alert] = "Email Not Found"
      render :login_form
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
