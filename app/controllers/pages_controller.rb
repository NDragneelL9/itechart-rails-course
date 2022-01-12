# Controller to pages entities
class PagesController < ApplicationController
  def index; end

  def graphics
    time_now = Time.zone.now
    @date_from = time_now.to_date.beginning_of_month
    @date_to = time_now.to_date.next_day
    transactions_date_range if params[:search].present?
    @personality = UserPersonality.find(params[:user_personality_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to user_personalities_path
  end

  private

  def transactions_date_range
    @date_from = Date.parse(params[:search][:date_from])
    @date_to = Date.parse(params[:search][:date_to])
  end
end
