class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: %w(PENDING APPROVED DENIED) }
  validate :dates_in_order
  validate :approved_requests_do_not_overlap

  belongs_to :cat

  after_initialize :set_default_status

  def approve!
    transaction do
      if pending? && overlapping_approved_requests.empty?
        self.status = "APPROVED"
        save!
        overlapping_requests.update_all(status: "DENIED")
      end
    end
  end

  def deny!
    self.status = 'DENIED'
    save
  end

  def overlapping_requests
    sql_fragment = <<-SQL
((start_date BETWEEN :start_date AND :end_date) OR
(end_date BETWEEN :start_date AND :end_date)) AND
(cat_id = :cat_id) AND
((id != :id) OR (id IS NULL))
SQL

    CatRentalRequest.where(
      sql_fragment,
      start_date: start_date,
      end_date: end_date,
      cat_id: cat_id,
      id: id
    )
  end

  def pending?
    status == "PENDING"
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: 'APPROVED')
  end

  def dates_in_order
    errors[:start_date] << "can't be after end date" if start_date > end_date
  end

  def approved_requests_do_not_overlap
    return if overlapping_approved_requests.empty? || status == 'DENIED'
    errors[:base] << "Can't overlap an already approved request"
  end

  def symbol
    case status
    when 'APPROVED'
      '✔'
    when 'PENDING'
      '‽'
    when 'DENIED'
      '✘'
    end
  end

  def render_dates
    date_f = '%b %d, \'%y'
    "#{start_date.strftime(date_f)} to #{end_date.strftime(date_f)}"
  end

  private

    def set_default_status
      status ||= 'PENDING'
    end
end
