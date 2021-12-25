class TransactionSearch
  attr_reader :date_from, :date_to, :notes, :category_id, :important

  def initialize(params)
    params ||= {}
    time_now = Time.zone.now
    @date_from = parsed_date(params[:date_from], time_now.last_month.to_date)
    @date_to = parsed_date(params[:date_to], time_now.to_date.next_day)
    @notes = params[:notes]
    @important = params[:important]
    @category_id = (params[:category_id]).to_i
  end

  def scope
    set_category
    @category.transactions.where('created_at BETWEEN ? AND ?',
                                 @date_from, @date_to)
  end

  def scope_notes
    set_category
    @category.transactions.joins(:notes).distinct.where('transactions.created_at BETWEEN ? AND ?',
                                                        @date_from, @date_to)
  end

  def scope_important
    set_category
    @category.transactions.where('created_at BETWEEN ? AND ? AND important = true',
                                 @date_from, @date_to)
  end

  def scope_important_notes
    set_category
    @category.transactions.joins(:notes).distinct.where('transactions.created_at BETWEEN ? AND ? AND important = true',
                                                        @date_from, @date_to)
  end

  private

  def parsed_date(date_string, default)
    Date.parse(date_string)
  rescue ArgumentError, TypeError
    Date.parse(default.to_s)
  end

  def set_category
    @category = Category.find(@category_id)
  rescue ActiveRecord::RecordNotFound
    'Record not found'
  end
end
