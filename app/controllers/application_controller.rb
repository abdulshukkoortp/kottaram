class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  before_action :authenticate_and_configure, :set_time_zone
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def authenticate_and_configure
  	redirect_to root_path unless current_user
  end

  alias devise_current_user current_user
  def current_user
    devise_current_user || token_user
  end

  def token_user
    @token_user ||= begin
      token = request.headers['AuthorizationToken']
      User.find_by_access_token(token) if token
    end
  end

  def set_time_zone
    Time.zone = 'Chennai'
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    error = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to request.referrer, flash: {error: error}
  end

  def month
    params[:date] ? (params[:date][:month] || Date.today.month) : Date.today.month
  end

  def year
    params[:date] ? (params[:date][:year] || Date.today.year) : Date.today.year
  end

  def date_time
    Time.new(year, month, '1', 0, 0 , 0)
  end
end
