class UsersController < ApplicationController
  def new_registration_form
    render({ :template => "users/signup_form.html.erb" })
  end

  def new_session_form
    render({ :template => "users/signin_form.html.erb" })
  end

  def sign_in
    username = params.fetch("input_username")
    password = params.fetch("input_password")
    user = User.where(:username => username).at(0)

    if user && user.authenticate(password)
      session.store(:user_id, user.id)

      redirect_to("/users/#{user.username}", { :notice => "Welcome, " + user.username })
    else
      p status
      p user.errors.full_messages[0]
      redirect_to("/user_sign_in", { :alert => "Sorry, you have an error.  Not able to log you in at this tiem" })
    end
  end

  def sign_out
    reset_session # goes through and deletes every key in the hash

    redirect_to("/", { :notice => "You've signed out!" })
  end

  def index
    @users = User.all.order({ :username => :asc })

    render({ :template => "users/index.html" })
  end

  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/show.html.erb" })
  end

  def create
    user = User.new
    user.username = params.fetch("input_username")
    user.password = params.fetch("input_password")
    user.password_confirmation = params.fetch("input_password_confirmation")
    status = user.save

    if status
      session.store(:user_id, user.id)

      redirect_to("/users/#{user.username}", { :notice => "Welcome, " + user.username })
    else
      p status
      p user.errors.full_messages[0]
      redirect_to("/user_sign_up", { :alert => "Sorry, you have an error: " + user.errors.full_messages[0] })
    end
  end

  def update
    the_id = params.fetch("the_user_id")
    user = User.where({ :id => the_id }).at(0)

    user.username = params.fetch("input_username")

    user.save

    redirect_to("/users/#{user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end
end
