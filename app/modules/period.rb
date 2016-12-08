class Period
  attr_accessor :previous_visits,
                :current_visits,
                :previous_page_views,
                :current_page_views,
                :current_start_date,
                :current_end_date


  def initialize(previous_period, current_period)
    @previous_visits = summarize_visits(previous_period)
    @current_visits = summarize_visits(current_period)
    @previous_page_views = summarize_page_views(previous_period)
    @current_page_views = summarize_page_views(current_period)
    @current_start_date = set_date(current_period[0][0])
    @current_end_date = set_date(current_period[-1][0])

  end

  def change_in_percent
    "#{self.change}%"
  end

  def change_status
    self.change.positive? ? 'increase' : 'decrease'
  end

 # private

  def summarize_visits(period)
    period.inject(0) { |sum, e| sum + e[1].to_i }
  end

  def summarize_page_views(period)
    period.inject(0) { |sum, e| sum + e[2].to_i }
  end

  def change
    (((self.current_visits.to_f / self.previous_visits) - 1)*100).round(1)
  end

  protected

  def set_date(index)
    Date.parse(index)
  end


end