class ChangeBirthDateType < ActiveRecord::Migration
  def change
    change_column :cats, :birth_date, :datetime
  end
end
