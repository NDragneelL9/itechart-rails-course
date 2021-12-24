class TransactionSearch
  attr_reader :date_from, :date_to, :only_notes, :category_id

  def initialize(params)
    params ||= {}
    @date_from = parsed_date(params[:date_from], Time.zone.now.last_month.to_date.to_s)
    @date_to = parsed_date(params[:date_to], Time.zone.now.to_date.to_s)
    @only_notes = params[:only_notes]
    @category_id = (params[:category_id]).to_i
  end

  def scope
    set_category
    @category.transactions.where('created_at BETWEEN ? AND ?',
                                 @date_from, @date_to)
  end

  def scope_with_notes
    set_category
    @category.transactions.joins(:notes).distinct.where('transactions.created_at BETWEEN ? AND ?',
                                                        @date_from, @date_to)
  end

  private

  def parsed_date(date_string, default)
    Date.parse(date_string)
  rescue ArgumentError, TypeError
    default
  end

  def set_category
    @category = Category.find(@category_id)
  rescue ActiveRecord::RecordNotFound
    'Record not found'
  end
end
