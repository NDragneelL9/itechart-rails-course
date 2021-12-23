class TransactionSearch
  attr_reader :date_from, :date_to, :only_notes

  def initialize(params)
    params ||= {}
    @date_from = parsed_date(params[:date_from], Time.zone.now.last_month.to_date.to_s)
    @date_to = parsed_date(params[:date_to], Time.zone.today.to_s)
    @only_notes = params[:only_notes]
  end

  def scope
    Transaction.where('created_at BETWEEN ? AND ?',
                      @date_from, @date_to)
  end

  def scope_with_notes
    Transaction.joins(:notes).distinct.where('transactions.created_at BETWEEN ? AND ?',
                                             @date_from, @date_to)
  end

  private

  def parsed_date(date_string, default)
    Date.parse(date_string)
  rescue ArgumentError, TypeError
    default
  end
end
