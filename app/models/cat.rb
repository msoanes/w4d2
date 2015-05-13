class Cat < ActiveRecord::Base
  COLORS = %w(black white gray tabby ginger)
  validates :birth_date, :color, :name, :sex, presence: true
  validates :color, inclusion: {
    in: COLORS,
    message: "%{value} is not a valid color"
  }
  validates :sex, inclusion: { in: %w(M F), message: "Select 'M' or 'F'" }

  has_many :rental_requests, class_name: 'CatRentalRequest', dependent: :destroy

  def age
    "#{ActionController::Base.helpers.time_ago_in_words(birth_date)} old"
  end

  def rendered_attrs
    {
      name: name,
      age: age,
      sex: sex,
      color: color,
      description: description
    }
  end
end
