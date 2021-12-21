class ApplicationController < ActionController::Base
  rescue_from StandardError, with: :standard_response
  rescue_from ActiveRecord::RecordNotFound, with: :standard_response
  rescue_from ActiveRecord::DeleteRestrictionError, with: :standard_response
  before_action :authenticate_user!

  private

  def standard_response(exception)
    @expection = exception.to_s
    render 'pages/error'
  end
end
