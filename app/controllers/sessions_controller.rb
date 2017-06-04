class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in_and_remember
      else
        notify_not_activated
      end
    else
      notify_invalid_logging_in
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def log_in_and_remember
    log_in @user
    params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
    redirect_back_or @user
  end

  def notify_not_activated
    message = 'Account not activated.'
    message += 'Check your email for the activation link.'
    flash[:warning] = message
    redirect_to root_url
  end

  def notify_invalid_logging_in
    flash.now[:danger] = 'Invalid email/password combination'
    render 'new'
  end
end
